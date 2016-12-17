defmodule Exhtml.TableTest do
  use ExUnit.Case

  doctest Exhtml.Table

  setup do
    Exhtml.Stash.start_link(%{}, %{})
    {:ok, pid} = Exhtml.Table.start_link
    Exhtml.Table.rm(pid, "foo")
    {:ok, %{pid: pid}}
  end

  test "get nonexisting content", %{pid: pid} do
    assert Exhtml.Table.get(pid, "nonexist") == nil
  end

  test "set content", %{pid: pid} do
    :ok = Exhtml.Table.set(pid, "foo", "bar")
    assert Exhtml.Table.get(pid, "foo") == "bar"
  end
end
