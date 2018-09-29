defmodule Exhtml.Supervisor do
  @moduledoc """
  Supervisor manages the supervisor tree of Exhtml.
  """

  use Supervisor

  @doc false
  def start_link(arg \\ []) do
    Supervisor.start_link(__MODULE__, arg)
  end

  @impl true
  def init(arg) do
    children = [
      {Exhtml.Host, Keyword.put(arg, :name, :exhtml_host)}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
