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


  def handle_call({:start, name, _}, _from, state) do
    case Map.get(state, name) do
      :running ->
        {:reply, {:already_started, state}, state}
      _ ->
        state = state |> Map.put(name, :running)
        {:reply, {:ok, state}, state}
    end
  end


  def handle_call({:stop, name}, _from, state) do
    state = state |> Map.delete(name)
    {:reply, :ok, state}
  end


  def handle_call({:status, name}, _from, state) do
    {:reply, Map.get(state, name) || :not_running, state}
  end



end
