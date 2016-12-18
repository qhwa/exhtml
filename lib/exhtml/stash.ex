defmodule Exhtml.Stash do

  @moduledoc """
  Stash save important states. Processes save their states to stash
  on crashing. They can restore states from Stash after restarts.

  This module is supposed not to be used publicly.
  """
  
  use GenServer

  @name __MODULE__
  @type server :: GenServer.server

  @doc false
  def start_link(reg_st, opts \\ []) do
    GenServer.start_link(__MODULE__, {reg_st}, name: opts[:name] || @name)
  end


  @doc """
  Saves the registry state.
  """
  @spec save_registry(server, any) :: :ok
  def save_registry(server \\ @name, state) do
    GenServer.call(server, {:save_registry_state, state})
  end


  @doc """
  Gets current stashed registry state.
  """
  def registry_state(server \\ @name) do
    GenServer.call(server, :get_registry_state)
  end


  # Callbacks

  def init(state) do
    {:ok, state}
  end


  def handle_call({:save_registry_state, reg}, _from, {_}) do
    {:reply, :ok, {reg}}
  end


  def handle_call(:get_registry_state, _from, current = {reg}) do
    {:reply, reg, current}
  end


end
