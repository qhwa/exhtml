defmodule Exhtml.SupervisorTest do
  use ExUnit.Case
  import Supervisor.Spec

  doctest Exhtml.Supervisor

  setup do
    {:ok, pid} = Exhtml.Supervisor.start_link
    {:ok, %{pid: pid}}
  end


  test "fetch content from storage", %{pid: pid} do
    assert Supervisor.count_children(pid) == %{active: 3, specs: 3, supervisors: 1, workers: 2}

    registry_pid = GenServer.whereis(:registry)
    assert Process.alive?(registry_pid)
  end
end
