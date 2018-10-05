defmodule Exhtml.Host do
  @moduledoc """
  Exhtml.Host represents the content server.
  """

  @type server :: GenServer.server()
  @type slug :: Exhtml.slug()

  use GenServer
  alias Exhtml.{Table, Storage}

  @doc """
  Starts a host.

  * `opts` - options for starting the process
      * `name` - the process name
      * `content_fetcher` - the content fetcher for `Exhtml.Storage`
      * `data_dir` - the database storage dir for `Exhtml.Table`
      * `data_nodes` - the database nodes for `Exhtml.Table`
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  @doc false
  def start_repo(server, opts) do
    GenServer.call(server, {:start_repo, opts})
  end

  @doc false
  def join_repo(server, remote, opts) do
    GenServer.call(server, {:join_repo, remote, opts})
  end

  @doc """
  Gets html content from a host.

  * `server` - the PID or name of the process
  * `slug` - the key of the content
  """
  @spec get_content(server, slug) :: any
  def get_content(server, slug) do
    GenServer.call(server, {:get_content, slug})
  end

  @doc """
  Gets html content from a host with cache time.

  * `server` - the PID or name of the process
  * `slug` - the key of the content
  * `time` - the modified time to check.
  """
  @spec get_content_since(server, slug, DateTime.t()) :: any
  def get_content_since(server, slug, time) do
    GenServer.call(server, {:get_content_since, slug, time})
  end

  @doc """
  Sets html content to a host with a slug.

  * `server` - the PID or name of the process
  * `slug` - the key of the content
  * `value` - the content to save

  Returns `:ok`.
  """
  @spec set_content(server, slug, any) :: :ok
  def set_content(server, slug, value) do
    GenServer.call(server, {:set_content, slug, value})
  end

  @doc """
  Fetchs and sets the content from the storage to a host's table.

  * `server` - the PID or name of the process
  * `slug` - the key of the content

  Returns content fetched.
  """
  @spec update_content(server, slug) :: any
  def update_content(server, slug) do
    GenServer.call(server, {:update_content, slug})
  end

  @doc """
  Deletes the content from a host.

  * `server` - the PID or name of the process
  * `slug` - the key of the content
  """
  @spec delete_content(server, slug) :: :ok
  def delete_content(server, slug) do
    GenServer.call(server, {:delete_content, slug})
  end

  @doc """
  Sets the content fetcher. A fetcher is used to fetch
  content from the data source, such as a remote server.

  * `server` - the PID or name of the process
  * `f` - function or module to fetch content
  """
  @spec set_content_fetcher(server, (slug -> any) | module) :: :ok
  def set_content_fetcher(server, f) do
    GenServer.call(server, {:set_content_fetcher, f})
  end

  ## Callbacks

  @doc false
  def init(opts) do
    {table, storage} = start_host_with_opts(opts)
    {:ok, {table, storage}}
  end

  def handle_call({:start_repo, opts}, _from, state) do
    state
    |> to_table_pid
    |> Table.start_repo(opts)
    |> to_reply(state)
  end

  def handle_call({:join_repo, remote, opts}, _from, state) do
    state
    |> to_table_pid
    |> Table.join_repo(remote, opts)
    |> to_reply(state)
  end

  def handle_call({:get_content, slug}, _from, state) do
    state
    |> to_table_pid
    |> get_content_from_table(slug)
    |> to_reply(state)
  end

  def handle_call({:get_content_since, slug, time}, _from, state) do
    state
    |> to_table_pid
    |> get_content_from_table(slug, time)
    |> to_reply(state)
  end

  def handle_call({:set_content, slug, value}, _from, state) do
    state
    |> to_table_pid
    |> set_content_to_table(slug, value)
    |> to_reply(state)
  end

  def handle_call({:update_content, slug}, _from, state) do
    {table_pid, storage_pid} = state
    content = Storage.fetch(storage_pid, slug)

    result =
      case set_content_to_table(table_pid, slug, content) do
        :ok -> content
        ret -> ret
      end

    {:reply, result, state}
  end

  def handle_call({:delete_content, slug}, _from, state) do
    state
    |> elem(0)
    |> Table.rm(slug)
    |> to_reply(state)
  end

  def handle_call({:set_content_fetcher, f}, _from, state) do
    state
    |> elem(1)
    |> Storage.set_fetcher(f)
    |> to_reply(state)
  end

  defp start_host_with_opts(opts) do
    {:ok, table_pid} = Table.start_link(opts)

    {:ok, storage_pid} =
      Storage.start_link(fetcher: opts[:content_fetcher] || Storage.DefaultStorage)

    {table_pid, storage_pid}
  end

  defp to_table_pid(state) do
    {table_pid, _storage_pid} = state
    table_pid
  end

  defp get_content_from_table(nil, _) do
    {:error, :not_running}
  end

  defp get_content_from_table(server, slug) do
    Table.get(server, slug)
  end

  defp get_content_from_table(server, slug, since) do
    Table.get_since(server, slug, since)
  end

  defp to_reply(ret, state) do
    {:reply, ret, state}
  end

  defp set_content_to_table(nil, _, _), do: {:error, :not_running}
  defp set_content_to_table(_, _slug, content = {:error, _}), do: content

  defp set_content_to_table(server, slug, content) do
    Table.set(server, slug, content)
  end
end
