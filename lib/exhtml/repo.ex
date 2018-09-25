defmodule Exhtml.Repo do

  use GenServer
  require Logger

  @moduledoc """
  Exhtml.Repo holds the core K/V data of the contents.
  """

  @table_name_in_db :exhtml_contents
  @default_data_dir "./exhtml_contents"

  @doc """
  Starts a mnesia repo.
  * `opts` - options for starting the process:
      * `data_dir` indicates which path the data will be persited in.
      * `data_nodes` indicates which nodes will hold persisted data. Other nodes
          will only hold data in memories.
  Returns `{:ok, pid}` if succeed, `{:error, reason}` otherwise.
  """

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end


  def stop(repo) do
    GenServer.stop(repo, :normal)
  end


  def join(remote_node, opts) do
    GenServer.start_link(__MODULE__, {:join, remote_node, opts})
  end


  def get(repo, slug) do
    GenServer.call(repo, {:get, slug})
  end


  def get_since(repo, slug, since) do
    GenServer.call(repo, {:get_since, slug, since})
  end


  def set(repo, slug, content) do
    GenServer.call(repo, {:set, slug, content})
  end


  def rm(repo, slug) do
    GenServer.call(repo, {:rm, slug})
  end


  def accept(new_node) do
    with _ <- :mnesia.change_config(:extra_db_nodes, [new_node]),
         _ <- :mnesia.add_table_copy(:schema, new_node, :disc_copies) do

      case :mnesia.add_table_copy(@table_name_in_db, new_node, :disc_copies) do
        {:atomic, :ok} ->
          Logger.debug(fn -> "accpeted new node: #{new_node}" end)
          :ok

        {:aborted, {:already_exists, _, _}} ->
          Logger.debug(fn -> "accpeted new node: #{new_node}" end)
          :ok

        err ->
          err
      end
    end
  end


  ## callbacks

  def init({:join, remote_node, opts}) do
    with true <- Node.connect(remote_node),
         :ok <- start_empty_db(opts),
         :ok <- :rpc.call(remote_node, Exhtml.Repo, :accept, [node()]) do
      {:ok, %{}}
    end
  end


  def init(opts) do
    start_db(
      opts[:data_dir] || @default_data_dir,
      opts[:data_nodes] || [node()]
    )

    {:ok, %{}}
  end
  

  defp start_db(data_dir, nodes) do
    Logger.debug(fn -> "starting repo, data dir: #{data_dir}" end)
    File.mkdir_p data_dir

    :mnesia |> :application.load
    :mnesia |> :application.set_env(:dir, to_charlist(data_dir))
    :mnesia |> :application.set_env(:auto_repair, true)

    :mnesia.create_schema(nodes)
    :mnesia.start
    :mnesia.create_table @table_name_in_db, attributes: [:slug, :content], disc_copies: nodes

    ret = :mnesia.wait_for_tables [@table_name_in_db], 5000

    case ret do
      {:timeout, _} ->
        Logger.error fn -> "Error starting exhtml databse, timeout." end
      {:error, reason} ->
        Logger.error fn -> "Error starting exhtml databse, #{inspect reason}." end
      _ ->
        nil
    end
    ret
  end


  defp start_empty_db(opts) do
    data_dir = opts[:data_dir] || @default_data_dir
    :mnesia |> :application.load
    :mnesia |> :application.set_env(:dir, to_charlist(data_dir))
    :mnesia |> :application.set_env(:auto_repair, true)
    :mnesia.start
  end

  def handle_call({:get, slug}, _from, state) do
    ret = slug
      |> db_result
      |> db_to_val

    {:reply, ret, state}
  end

  def handle_call({:get_since, slug, since}, _from, state) do
    val = slug
      |> db_result
      |> db_to_val_with_time

    ret = case val do
      nil             -> nil
      {nil, nil}      -> nil
      {content, nil}  -> {:ok, content}
      {content, t}    -> to_content_since(content, t, since)
      _               -> {:ok, val}
    end

    {:reply, ret, state}
  end

  def handle_call({:set, slug, content}, _from, state) do
    {:atomic, _} = :mnesia.transaction(fn ->
      :mnesia.write(@table_name_in_db, {@table_name_in_db, slug, {content, DateTime.utc_now}}, :write)
    end)
    {:reply, :ok, state}
  end

  def handle_call({:rm, slug}, _from, state) do
    {:atomic, _} = :mnesia.transaction(fn ->
      :mnesia.delete(@table_name_in_db, slug, :write)
    end)
    {:reply, :ok, state}
  end

  defp db_result(slug) do
    @table_name_in_db |> :mnesia.dirty_read(slug) |> List.first
  end

  defp db_to_val(nil), do: nil
  defp db_to_val({@table_name_in_db, _slug, {content, _t}}), do: content
  defp db_to_val({@table_name_in_db, _slug, content}), do: content

  defp db_to_val_with_time(nil), do: nil
  defp db_to_val_with_time({@table_name_in_db, _slug, {content, mtime}}), do: {content, mtime}
  defp db_to_val_with_time({@table_name_in_db, _slug, content}), do: {content, nil}

  defp to_content_since(content, _, nil), do: {:ok, content}
  defp to_content_since(content, t, since) do
    case DateTime.compare(t, since) do
      :lt -> :unchanged
      _ -> {:ok, content}
    end
  end

end
