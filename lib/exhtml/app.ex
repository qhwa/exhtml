defmodule Exhtml.App do

  import Logger
  
  @moduledoc """
  This is the Application specification of Exhtml.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Exhtml.Supervisor, [Application.get_all_env :exhtml])
    ]

    Logger.debug "Exhtml application started"
    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end

  def stop(_state) do
    debug("Exhtml application stopped")
  end

end
