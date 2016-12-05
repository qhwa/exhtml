defmodule Exhtml.Table do
  
  @moduledoc """
  Exhtml.Table is a group of HTML contents.
  """

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get(slug) do
    GenServer.call(__MODULE__, {:get, slug})
  end

  def set(slug, content) do
    GenServer.call(__MODULE__, {:set, slug, content})
  end

  def rm(slug) do
    GenServer.call(__MODULE__, {:rm, slug})
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
    {:reply, {:ok, state}, state}
  end

  def handle_call({:rm, slug}, _from, state) do
    state = state
      |> Map.delete(slug)
    {:reply, {:ok, state}, state}
  end

end
