defmodule Exhtml.StorageTest do
  use ExUnit.Case

  alias Exhtml.Storage
  doctest Storage

  setup do
    {:ok, pid} = Storage.start_link(fetcher: Storage.TestStorage)
    {:ok, %{pid: pid}}
  end

  test "fetch content from storage", %{pid: pid} do
    assert Storage.fetch(pid, "foo") == "FOO"
  end

  test "set content fetcher", %{pid: pid} do
    assert Storage.set_fetcher(pid, fn _slug -> :intersting end) == :ok
    assert Storage.fetch(pid, :anything) == :intersting
  end

  test "unset fetcher" do
    {:ok, pid} = Storage.start_link(fetcher: fn _ -> :good end)
    assert Storage.set_fetcher(pid, nil) == :ok
    assert Storage.fetch(pid, :hi) == nil
  end
end
