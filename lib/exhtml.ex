defmodule Exhtml do

  use Application

  @moduledoc """
  Exhtml serves HTML contents.
  It fetches content from backend storage and saves in
  its state. HTML contents are responded to user directly
  from state.
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Exhtml.Host, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
