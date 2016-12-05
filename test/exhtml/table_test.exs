defmodule Exhtml.TableTest do
  use ExUnit.Case

  doctest Exhtml.Table

  setup do
    Exhtml.Table.start_link
    Exhtml.Table.rm("foo")
    :ok
  end

  test "get nonexisting content" do
    assert Exhtml.Table.get("nonexist") == nil
  end

  test "set content" do
    {:ok, state} = Exhtml.Table.set("foo", "bar")
    assert Exhtml.Table.get("foo") == "bar"
  end
end
