defmodule Exhtml.Host.Supervisor do
  
  use Supervisor

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init(args) do
    children = [
      worker(Exhtml.Host, [args])
    ]
    supervise(children, strategy: :one_for_all)
  end

end
