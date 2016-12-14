defmodule Exhtml.Host do

  @moduledoc """
  Exhtml.Host represents the content server.
  """

  use GenServer

  @doc """
  Starts a host with a name.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @doc """
  Gets html content from a host.
  """
  def get_content(pid, slug) do
    GenServer.call(pid, {:get_content, slug})
  end


  @doc """
  Sets html content to a host with a slug.
  """
  def set_content(pid, slug, value) do
    GenServer.call(pid, {:set_content, slug, value})
  end


  @doc """
  Fetchs and sets the content from the storage to a host's table.
  """
  def update_content(pid, slug) do
    GenServer.call(pid, {:update_content, slug})
  end


  @doc """
  Deletes the content from a host.
  """
  def delete_content(pid, slug) do
    GenServer.call(pid, {:delete_content, slug})
  end


  ## Callbacks


  def init(opts) do
    {table, storage} = start_host_with_opts(opts)
    {:ok, {table, storage}}
  end


  def handle_call({:get_content, slug}, _from, state) do
    state
      |> to_table_pid
      |> get_content_from_table(slug)
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
    content = Exhtml.Storage.fetch(storage_pid, slug)
    {:ok, _} = Exhtml.Table.set(table_pid, slug, content)

    {:reply, content, state}
  end


  def handle_call({:delete_content, slug}, _from, state) do
    state
      |> elem(0)
      |> Exhtml.Table.rm(slug)
      |> to_reply(state)
  end


  defp start_host_with_opts(opts) do
    # Table crash 并重启后，这里的 table_pid 没有及时更新
    # 会造成问题
    # FIXME: 修复这里的问题
    {:ok, table_pid}   = Exhtml.Table.start_link
    {:ok, storage_pid} = Exhtml.Storage.start_link(
      engine: opts[:storage_engine] || Exhtml.Storage.DefaultStorage
    )

    {table_pid, storage_pid}
  end


  defp to_table_pid(state) do
    {table_pid, _storage_pid} = state
    table_pid
  end


  defp get_content_from_table(nil, _) do
    {:error, :not_running}
  end


  defp get_content_from_table(pid, slug) do
    Exhtml.Table.get(pid, slug)
  end


  defp to_reply(ret, state) do
    {:reply, ret, state}
  end


  defp set_content_to_table(nil, _, _) do
    {:error, :not_running}
  end


  defp set_content_to_table(pid, slug, content) do
    Exhtml.Table.set(pid, slug, content)
  end

end
