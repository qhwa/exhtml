defmodule Exhtml.TableTest do
  use ExUnit.Case

  doctest Exhtml.Table

  setup do
    Exhtml.Table.start_link
    :ok
  end

  test "get nonexisting content" do
    assert Exhtml.Table.get("nonexist") == nil
  end

  test "fetch content" do
    assert Exhtml.Table.fetch("new-slug") == "NEW-SLUG"
    assert Exhtml.Table.get("new-slug") == "NEW-SLUG"
  end
end
