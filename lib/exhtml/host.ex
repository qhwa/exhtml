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
    GenServer.call(__MODULE__, {:start, name, opts})
  end


  @doc """
  Stops some host.
  """
  def stop(name) do
    GenServer.call(__MODULE__, {:stop, name})
  end


  @doc """
  Shows the status of some host.
  """
  def status(name) do
    GenServer.call(__MODULE__, {:status, name})
  end


  @doc """
  Gets html content from a host.
  """
  def get_content(name, slug) do
    GenServer.call(__MODULE__, {:get_content, name, slug})
  end


  @doc """
  Sets html content to a host with a slug.
  """
  def set_content(name, slug, value) do
    GenServer.call(__MODULE__, {:set_content, name, slug, value})
  end


  @doc """
  Fetchs and sets the content from the storage to a host's table.
  """
  def update_content(name, slug) do
    GenServer.call(__MODULE__, {:update_content, name, slug})
  end


  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end


  def handle_call({:start, name, opts}, _from, state) do
    if is_running?(state, name) do
      {:reply, {:already_started, state[name]}, state}
    else
      {:ok, pids} = start_host_with_opts(name, opts)
      state = state |> Map.put(name, pids)
      {:reply, :ok, state}
    end
  end


  def handle_call({:stop, name}, _from, state) do
    if is_running?(state, name) do
      {table_pid, storage_pid} = state[name]
      GenServer.stop(table_pid, :normal)
      GenServer.stop(storage_pid, :normal)
      {:reply, :ok, Map.delete(state, name)}
    else
      {:reply, :ok, state}
    end
  end


  def handle_call({:status, name}, _from, state) do
    status = if is_running?(state, name), do: :running, else: :not_running
    {:reply, status, state}
  end


  def handle_call({:get_content, name, slug}, _from, state) do
    state
      |> to_table_pid(name)
      |> get_content_from_table(slug)
      |> to_reply(state)
  end


  def handle_call({:set_content, name, slug, value}, _from, state) do
    state
      |> to_table_pid(name)
      |> set_content_to_table(slug, value)
      |> to_reply(state)
  end


  def handle_call({:update_content, name, slug}, _from, state) do
    {table_pid, storage_pid} = state[name]
    content = Exhtml.Storage.fetch(storage_pid, slug)
    {:ok, _} = Exhtml.Table.set(table_pid, slug, content)

    {:reply, content, state}
  end


  defp is_running?(state, name) do
    Map.get(state, name) != nil
  end


  defp start_host_with_opts(_name, opts) do
    {:ok, table_pid}   = Exhtml.Table.start_link
    {:ok, storage_pid} = Exhtml.Storage.start_link(
      engine: opts[:storage_engine] || Exhtml.Storage.DefaultStorage
    )

    {:ok, {table_pid, storage_pid}}
  end


  defp to_table_pid(state, name) do
    case Map.get(state, name) do
      {table_pid, _} -> table_pid
      nil -> nil
    end
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
