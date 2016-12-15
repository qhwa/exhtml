defmodule Exhtml.Supervisor do
  
  use Supervisor

  def start_link(arg \\ []) do
    {:ok, sup} = Supervisor.start_link(__MODULE__, arg)
    start_workers(sup, arg)
  end


  defp start_workers(sup, arg) do
    registry_state = %{a: 1}
    table_state = %{slug: "Value"}

    {:ok, _} = Supervisor.start_child(
      sup,
      worker(Exhtml.Stash, [registry_state, table_state])
    )

    {:ok, _} = Supervisor.start_child(
      sup,
      supervisor(Exhtml.Registry.Supervisor, [])
    )

    {:ok, _} = Supervisor.start_child(
      sup,
      supervisor(Exhtml.Host.Supervisor, [[name: :exhtml_host]])
    )
    {:ok, sup}
  end


  def init(_) do
    supervise([], strategy: :one_for_one)
  end



end
