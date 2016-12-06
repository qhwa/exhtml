defmodule Exhtml.Storage do
  
  use GenServer

  def start_link(engine: engine) do
    GenServer.start_link(__MODULE__, [engine: engine])
  end

  def fetch(pid, slug) do
    GenServer.call(pid, {:fetch, slug})
  end

  def handle_call({:fetch, slug}, _from, state = [engine: engine]) do
    {:reply, apply(engine, :fetch, [slug]), state}
  end

end
