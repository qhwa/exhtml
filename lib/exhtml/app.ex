defmodule Exhtml.App do

  import Logger
  
  @moduledoc """
  This is the Application specification of Exhtml.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Exhtml.Supervisor, [])
    ]

    Logger.debug "Exhtml application started"
    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end

  def stop(state) do
    debug("Exhtml application stopped")
  end

end
