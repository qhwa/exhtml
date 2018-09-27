defmodule Exhtml.App do

  import Logger
  
  @moduledoc false

  use Application

  @doc false
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
