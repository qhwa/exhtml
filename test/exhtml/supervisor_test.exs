defmodule Exhtml.SupervisorTest do

  use ExUnit.Case

  doctest Exhtml.Supervisor

  setup do
    {:ok, _} = Exhtml.Supervisor.start_link
    :ok
  end


  test "registry should be started" do
    assert Exhtml.Registry.whereis(:a) == 1
  end

  test "host should be started" do
    {:ok, pid} = Exhtml.Host.Supervisor.start_link name: :test_host
    assert Process.alive?(pid)
    assert GenServer.whereis(:test_host)
  end

  test "table should start from stash" do
    assert Exhtml.Host.get_content(:exhtml_host, :slug) == "Value"
  end
end
