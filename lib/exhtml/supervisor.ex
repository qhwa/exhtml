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
    Supervisor.start_child(
      sup,
      worker(Exhtml.Host, [
        Keyword.put(opts, :name, :exhtml_host)
      ])
    )

    {:ok, sup}
  end


  @doc false
  def init(_) do
    supervise([], strategy: :one_for_one)
  end



end
