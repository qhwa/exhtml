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


  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end


  def handle_call({:start, name, opts}, _from, state) do
    if is_running?(state, name) do
      {:reply, {:already_started, state[name]}, state}
    else
      {:ok, pid} = start_host_with_opts(name, opts)
      state = state |> Map.put(name, pid)
      {:reply, {:ok, pid}, state}
    end
  end


  def handle_call({:stop, name}, _from, state) do
    if is_running?(state, name) do
      pid = state[name]
      true = Process.exit(pid, :kill)
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
      |> to_pid(name)
      |> get_content_from_table(slug)
      |> to_reply(state)
  end


  def handle_call({:set_content, name, slug, value}, _from, state) do
    state
      |> to_pid(name)
      |> set_content_to_table(slug, value)
      |> to_reply(state)
  end


  defp is_running?(state, name) do
    Map.get(state, name) != nil
  end


  defp start_host_with_opts(_name, _opts) do
    Exhtml.Table.start_link
  end


  defp to_pid(state, name) do
    Map.get(state, name)
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
