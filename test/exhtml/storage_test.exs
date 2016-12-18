defmodule Exhtml.StorageTest do
  use ExUnit.Case

  doctest Exhtml.Storage

  setup do
    {:ok, pid} = Exhtml.Storage.start_link(fetcher: Exhtml.Storage.TestStorage)
    {:ok, %{pid: pid}}
  end

  test "fetch content from storage", %{pid: pid} do
    assert Exhtml.Storage.fetch(pid, "foo") == "FOO"
  end

  test "set content fetcher", %{pid: pid} do
    assert Exhtml.Storage.set_fetcher(pid, fn _slug -> :intersting end)
    assert Exhtml.Storage.fetch(pid, :anything) == :intersting
  end
end
