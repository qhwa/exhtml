defmodule Exhtml.Storage do

  @moduledoc """
  Storage provides a `fetch` method used to fetch content from outside
  source.
  """
  
  use GenServer

  def start_link(engine: engine) do
    GenServer.start_link(__MODULE__, [engine: engine])
  end

  def fetch(pid, slug) do
    GenServer.call(pid, {:fetch, slug})
  end

  def set_fetcher(pid, f) do
    GenServer.call(pid, {:set_fetcher, f})
  end

  def handle_call({:fetch, slug}, _from, state) do
    content = fetch_content(slug, state[:fetcher], state[:engine])
    {:reply, content, state}
  end

  def handle_call({:set_fetcher, f}, _from, state) do
    {:reply, :ok, Keyword.put(state, :fetcher, f)}
  end

  defp fetch_content(slug, nil, nil) do
    nil
  end

  defp fetch_content(slug, fetcher, _) when is_function(fetcher) do
    fetcher.(slug)
  end

  defp fetch_content(slug, nil, engine) do
    apply engine, :fetch, [slug]
  end

end
