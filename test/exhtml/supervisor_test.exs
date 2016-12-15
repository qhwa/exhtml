defmodule Exhtml.SupervisorTest do
  use ExUnit.Case

  doctest Exhtml.Supervisor

  setup do
    {:ok, pid} = Exhtml.Supervisor.start_link
    {:ok, %{pid: pid}}
  end


  test "fetch content from storage", %{pid: pid} do
    assert Supervisor.count_children(pid) == %{active: 3, specs: 3, supervisors: 2, workers: 1}

    registry_pid = GenServer.whereis(:registry)
    assert Process.alive?(registry_pid)
  end

  test "start host supervisor" do
    {:ok, pid} = Exhtml.Host.Supervisor.start_link name: :test_host
    assert Process.alive?(pid)
    assert GenServer.whereis(:test_host)
  end
end
