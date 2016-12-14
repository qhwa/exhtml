defmodule Exhtml.Supervisor do
  
  use Supervisor

  def start_link(arg \\ []) do
    {:ok, sup} = Supervisor.start_link(__MODULE__, arg)
    start_workers(sup, arg)
  end


  defp start_workers(sup, arg) do
    Supervisor.start_child(
      sup,
      worker(Exhtml.Stash, [%{a: 1}, %{slug: "Value"}])
    )

    Supervisor.start_child(
      sup,
      supervisor(Exhtml.Registry.Supervisor, [])
    )

    Supervisor.start_child(
      sup,
      worker(Exhtml.Host, [])
    )
    {:ok, sup}
  end


  def init(_) do
    supervise([], strategy: :one_for_one)
  end



end
