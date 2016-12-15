defmodule Exhtml.Stash do
  
  use GenServer

  @name __MODULE__

  def start_link(registry_state, table_state) do
    ret = GenServer.start_link(__MODULE__, {registry_state, table_state}, name: @name)
      |> ensure_fully_started_when_test(Mix.env)

    case ret do
      {:ok, _} -> ret
      :retry ->
        start_link(registry_state, table_state)
    end
  end


  def save_registry(state) do
    GenServer.call(@name, {:save_registry_state, state})
  end


  def registry_state do
    GenServer.call(@name, :get_registry_state)
  end


  def save_table(state) do
    GenServer.call(@name, {:save_table_state, state})
  end


  def table_state do
    GenServer.call(@name, :get_table_state)
  end


  # Callbacks

  def init(state) do
    {:ok, state}
  end


  def handle_call({:save_registry_state, reg}, _from, {_, table_state}) do
    {:reply, :ok, {reg, table_state}}
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


  defp ensure_fully_started_when_test(ret, :test) do
    case ret do
      {:ok, _} -> ret
      {:error, {:already_started, _}} -> 
        :timer.sleep 50
        :retry
    end
  end


  defp ensure_fully_started_when_test(ret, _) do
    ret
  end

end
