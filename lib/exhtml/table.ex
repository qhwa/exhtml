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

  def fetch(slug) do
    GenServer.call(__MODULE__, {:fetch, slug})
  end

  def handle_call({:get, slug}, _from, state) do
    {:reply, Map.get(state, slug), state}
  end

  def handle_call({:fetch, slug}, _from, state) do
    content = fetch_content(slug)
    state = state
      |> Map.put(
        slug,
        content
      )
    {:reply, content, state}
  end

  defp fetch_content(slug) do
    # TODO: fetch content from storage
    slug |> to_string |> String.upcase
  end

end
