defmodule Exhtml.SupervisorTest do

  use ExUnit.Case

  doctest Exhtml.Supervisor

  setup do
    {:ok, _} = Exhtml.Supervisor.start_link
    :ok
  end


  test "registry should be started" do
    assert Exhtml.Registry.whereis(:ping) == :pong
  end

end
