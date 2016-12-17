defmodule Exhtml.Supervisor do

  @moduledoc """
  Supervisor manages the supervisor tree of Exhtml.
  """
  
  use Supervisor

  def start_link(arg \\ []) do
    {:ok, sup} = Supervisor.start_link(__MODULE__, arg)
    start_workers(sup, arg)
  end


  defp start_workers(sup, opts) do
    registry_state = %{ping: :pong}
    table_state    = %{ping: :pong}

    {:ok, _} = Supervisor.start_child(
      sup,
      worker(Exhtml.Stash, [registry_state, table_state])
    )

    {:ok, _} = Supervisor.start_child(
      sup,
      worker(Exhtml.Registry, [])
    )

    {:ok, _} = Supervisor.start_child(
      sup,
      worker(Exhtml.Host, [[
        name: :exhtml_host,
        content_fetcher: opts[:content_fetcher]
      ]])
    )

    {:ok, sup}
  end


  def init(_) do
    supervise([], strategy: :one_for_one)
  end



end
