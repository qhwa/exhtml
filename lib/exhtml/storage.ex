defmodule Exhtml.Storage do
  
  use GenServer

  def start_link(engine: engine) do
    GenServer.start_link(__MODULE__, [engine: engine], name: __MODULE__)
  end

  def fetch(slug) do
    GenServer.call(__MODULE__, {:fetch, slug})
  end

  def handle_call({:fetch, slug}, _from, state = [engine: engine]) do
    {:reply, apply(engine, :fetch, [slug]), state}
  end

end
