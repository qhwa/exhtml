defmodule Exhtml.Repo.DefaultTest do
  use ExUnit.Case
  import TestHelper

  doctest Exhtml.Repo.Default

  setup do
    Exhtml.Stash.start_link(%{}, %{})
    {:ok, pid} = Exhtml.Repo.Default.start_link []
    Exhtml.Repo.Default.rm(pid, "foo")
    {:ok, %{pid: pid}}
  end

  test "get nonexisting content", %{pid: pid} do
    assert Exhtml.Repo.Default.get(pid, "nonexist") == nil
  end

  test "set content", %{pid: pid} do
    :ok = Exhtml.Repo.Default.set(pid, "foo", "bar")
    assert Exhtml.Repo.Default.get(pid, "foo") == "bar"
  end

  test "set data_dir" do
    assert Application.get_env(:mnesia, :dir) == './exhtml_contents'
  end

  test ".get_content_since of nonexist", %{pid: pid} do
    assert Exhtml.Repo.Default.get_since(pid, "nonexist", nil) == nil
    assert Exhtml.Repo.Default.get_since(pid, "nonexist", DateTime.utc_now) == nil
  end

  test ".get_content_since of existing key", %{pid: pid} do
    :ok = Exhtml.Repo.Default.set(pid, "foo", :bar)

    assert Exhtml.Repo.Default.get_since(pid, "foo", nil) == {:ok, :bar}
    assert Exhtml.Repo.Default.get_since(pid, "foo", DateTime.utc_now) == :unchanged
    assert Exhtml.Repo.Default.get_since(pid, "foo", yesterday()) == {:ok, :bar}
  end

end
