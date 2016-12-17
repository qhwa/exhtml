defmodule Exhtml.Stash do

  @moduledoc """
  Stash save important states. Processes save their states to stash
  on crashing. They can restore states from Stash after restarts.
  """
  
  use GenServer

  @name __MODULE__

  def start_link(reg_st, table_st, opts \\ []) do
    GenServer.start_link(__MODULE__, {reg_st, table_st}, name: opts[:name] || @name)
  end


  def save_registry(pid \\ @name, state) do
    GenServer.call(pid, {:save_registry_state, state})
  end


  def registry_state(pid \\ @name) do
    GenServer.call(pid, :get_registry_state)
  end


  def save_table(pid \\ @name, state) do
    GenServer.call(pid, {:save_table_state, state})
  end


  def table_state(pid \\ @name) do
    GenServer.call(pid, :get_table_state)
  end


  # Callbacks

  def init(state) do
    {:ok, state}
  end


  def handle_call({:save_registry_state, reg}, _from, {_, table_st}) do
    {:reply, :ok, {reg, table_st}}
  end


  def handle_call(:get_registry_state, _from, current = {reg, _}) do
    {:reply, reg, current}
  end


  def handle_call({:save_table_state, table}, _from, {reg, _}) do
    {:reply, :ok, {reg, table}}
  end


  def handle_call(:get_table_state, _from, current = {_, table}) do
    {:reply, table, current}
  end

end
