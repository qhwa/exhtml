defmodule Exhtml.StorageTest do
  use ExUnit.Case

  doctest Exhtml.Storage

  setup do
    Exhtml.Storage.start_link(engine: Exhtml.Storage.TestStorage)
    :ok
  end

  test "fetch content from storage" do
    assert Exhtml.Storage.fetch("foo") == "FOO"
  end
end
