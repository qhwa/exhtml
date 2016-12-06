defmodule Exhtml.Host do

  @moduledoc """
  Exhtml.Host represents the content server.
  You can start/stop/status a host.
  """

  use GenServer

  @doc """
  Starts a host with a name.
  """
  def start(name, opts \\ []) do
    GenServer.start_link(__MODULE__, {name, opts})
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


  ## Callbacks


  def init({name, opts}) do
    {table, storage} = start_host_with_opts(opts)
    {:ok, {name, table, storage}}
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
    {_name, table_pid, storage_pid} = state
    content = Exhtml.Storage.fetch(storage_pid, slug)
    {:ok, _} = Exhtml.Table.set(table_pid, slug, content)

    {:reply, content, state}
  end


  defp start_host_with_opts(opts) do
    {:ok, table_pid}   = Exhtml.Table.start_link
    {:ok, storage_pid} = Exhtml.Storage.start_link(
      engine: opts[:storage_engine] || Exhtml.Storage.DefaultStorage
    )

    {table_pid, storage_pid}
  end


  defp to_table_pid(state) do
    {_name, table_pid, _storage_pid} = state
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
