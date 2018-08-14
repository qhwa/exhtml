defmodule Exhtml.Supervisor do
  @moduledoc """
  Supervisor manages the supervisor tree of Exhtml.
  """

  use Supervisor

  @doc false
  def start_link(arg \\ []) do
    {:ok, sup} = Supervisor.start_link(__MODULE__, arg)
    start_workers(sup, arg)
  end

  defp start_workers(sup, opts) do
    registry_state = %{ping: :pong}

    Supervisor.start_child(
      sup,
      worker(Exhtml.Stash, [registry_state])
    )

    Supervisor.start_child(
      sup,
      worker(Exhtml.Host, [
        Keyword.put(opts, :name, :exhtml_host)
      ])
    )

    {:ok, sup}
  end

  def init(_) do
    supervise([], strategy: :one_for_one)
  end
end
