defmodule Exhtml.Table do
  
  @moduledoc """
  Exhtml.Table is a group of HTML contents.
  """

  use GenServer

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, Exhtml.Stash.table_state)
  end

  def get(ns, slug) do
    GenServer.call(ns, {:get, slug})
  end

  def set(ns, slug, content) do
    GenServer.call(ns, {:set, slug, content})
  end

  def rm(ns, slug) do
    GenServer.call(ns, {:rm, slug})
  end

  def handle_call({:get, slug}, _from, state) do
    {:reply, Map.get(state, slug), state}
  end

  def handle_call({:set, slug, content}, _from, state) do
    state = state
      |> Map.put(
        slug,
        content
      )
    {:reply, :ok, state}
  end

  def handle_call({:rm, slug}, _from, state) do
    state = state
      |> Map.delete(slug)
    {:reply, {:ok, state}, state}
  end

  def terminate(_, state) do
    Exhtml.Stash.save_table(state)
  end

end
