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
  Show the status of some host
  """
  def status(name) do
    GenServer.call(__MODULE__, {:status, name})
  end


  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end


  def handle_call({:start, name, opts}, _from, state) do
    case Map.get(state, name) do
      nil ->
        {:ok, pid} = start_host_with_opts(name, opts)
        state = state |> Map.put(name, pid)
        {:reply, {:ok, pid}, state}
      _ ->
        {:reply, {:already_started, state[name]}, state}
    end
  end


  def handle_call({:stop, name}, _from, state) do
    case Map.get(state, name) do
      pid when is_pid(pid) ->
        true = Process.exit(pid, :kill)
        {:reply, :ok, Map.delete(state, name)}

      nil ->
        {:reply, :ok, state}
    end
  end


  def handle_call({:status, name}, _from, state) do
    status = if Map.get(state, name), do: :running, else: :not_running
    {:reply, status, state}
  end


  defp start_host_with_opts(_name, _opts) do
    Exhtml.Table.start_link
  end



end
