defmodule Exhtml.Registry do

  @moduledoc """
  Registry holds information of mapping of PIDs to names.
  """

  use GenServer
  
  @name :registry

  # APIs

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: opts[:name] || @name)
  end


  def register(key, value) do
    GenServer.call(@name, {:register, key, value})
  end


  def whereis(key) do
    GenServer.call(@name, {:whereis, key})
  end


  # Callbacks

  def init(_opts) do
    {:ok, Exhtml.Stash.registry_state || %{}}
  end


  def handle_call({:register, key, value}, _from, state) do
    state = state |> Map.put(key, value)
    {:reply, :ok, state}
  end

  
  def handle_call({:whereis, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end


  def terminate(_, state) do
    Exhtml.Stash.save_registry(state)
  end

end
