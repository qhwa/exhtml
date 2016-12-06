defmodule Exhtml.TableTest do
  use ExUnit.Case

  doctest Exhtml.Table
  @namespace :test_namespace

  setup do
    Exhtml.Table.start_link(name: @namespace)
    Exhtml.Table.rm(@namespace, "foo")
    :ok
  end

  test "get nonexisting content" do
    assert Exhtml.Table.get(@namespace, "nonexist") == nil
  end

  test "set content" do
    {:ok, state} = Exhtml.Table.set(@namespace, "foo", "bar")
    assert state["foo"] == "bar"
    assert Exhtml.Table.get(@namespace, "foo") == "bar"
  end
end
