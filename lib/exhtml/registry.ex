defmodule Exhtml.Registry do

  @moduledoc """
  Registry holds information of mapping of PIDs to names.

  ## Examples:

      iex> Exhtml.Registry.start_link
      ...> Exhtml.Registry.register(:foo, :bar)
      :ok
      iex> Exhtml.Registry.whereis(:foo)
      :bar
  """

  use GenServer
  
  @name {:global, :registry}

  # APIs

  @doc """
  Starts a registry process.
  """
  @spec start_link([key: any]) :: {:ok, pid} | {:error, any}
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: opts[:name] || @name)
  end


  @doc """
  Registers a pid to name.

  * `key` the name of the PID.
  * `value` the PID.
  """
  def register(key, value) do
    GenServer.call(@name, {:register, key, value})
  end


  @doc """
  Maps a name to PID.

  Returns ths PID associated with the key, otherwise `nil`.
  """
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
