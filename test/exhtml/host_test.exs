defmodule ExhtmlTest.HostTest do
  use ExUnit.Case
  doctest Exhtml.Host

  setup do
    Exhtml.Host.start_link
    :ok
  end

  test "get running status" do
    assert Exhtml.Host.status(:foo) == :not_running
  end

  test "start a host" do
    {:ok, pid} = Exhtml.Host.start(:foo, [])
    assert Process.alive?(pid)
  end

  test "get status of a host" do
    Exhtml.Host.start(:foo, [])
    assert Exhtml.Host.status(:foo) == :running
  end

  test "stop a host" do
    {:ok, pid} = Exhtml.Host.start(:foo, [])
    Exhtml.Host.stop(:foo)

    refute Process.alive?(pid)
  end

  test "get content by name and slug" do
    Exhtml.Host.start(:foo, [])
    assert Exhtml.Host.get_content(:foo, :hello_page) == nil
  end

  test "set content by name and slug" do
    Exhtml.Host.start(:foo, [])
    Exhtml.Host.set_content(:foo, :hello_page, "~~~")
    assert Exhtml.Host.get_content(:foo, :hello_page) == "~~~"
  end
end
