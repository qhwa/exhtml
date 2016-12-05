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
    {:ok, state} = Exhtml.Host.start(:foo, [])
    assert state[:foo] == :running
  end

  test "get status of a host" do
    Exhtml.Host.start(:foo, [])
    assert Exhtml.Host.status(:foo) == :running
  end
end
