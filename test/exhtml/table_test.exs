defmodule Exhtml.TableTest do
  use ExUnit.Case
  import TestHelper

  doctest Exhtml.Table

  describe "before all set" do

    setup do
      Exhtml.Stash.start_link(%{}, %{})
      {:ok, pid} = Exhtml.Table.start_link auto_start_repo: false
      Exhtml.Table.rm(pid, "foo")
      {:ok, %{pid: pid}}
    end

    test "get nonexisting content", %{pid: pid} do
      assert Exhtml.Table.get(pid, "nonexist") == {:error, :repo_not_started}
    end

    test "set content", %{pid: pid} do
      assert Exhtml.Table.set(pid, "foo", "bar") == {:error, :repo_not_started}
    end

    test ".get_content_since of nonexist", %{pid: pid} do
      assert Exhtml.Table.get_since(pid, "nonexist", nil) == {:error, :repo_not_started}
    end
  end

  describe "after all set" do

    setup do
      Exhtml.Stash.start_link(%{}, %{})
      {:ok, pid} = Exhtml.Table.start_link auto_start_repo: false
      Exhtml.Table.start_repo(pid, [])

      {:ok, %{pid: pid}}
    end

    test "get nonexisting content", %{pid: pid} do
      assert Exhtml.Table.get(pid, "nonexist") == nil
    end

    test "set content", %{pid: pid} do
      :ok = Exhtml.Table.set(pid, "foo", "bar")
      assert Exhtml.Table.get(pid, "foo") == "bar"
    end

    test "set data_dir" do
      assert Application.get_env(:mnesia, :dir) == './exhtml_contents'
    end

    test ".get_content_since of nonexist", %{pid: pid} do
      assert Exhtml.Table.get_since(pid, "nonexist", nil) == nil
      assert Exhtml.Table.get_since(pid, "nonexist", DateTime.utc_now) == nil
    end

    test ".get_content_since of existing key", %{pid: pid} do
      :ok = Exhtml.Table.set(pid, "foo", :bar)

      assert Exhtml.Table.get_since(pid, "foo", nil) == {:ok, :bar}
      assert Exhtml.Table.get_since(pid, "foo", DateTime.utc_now) == :unchanged
      assert Exhtml.Table.get_since(pid, "foo", yesterday()) == {:ok, :bar}
    end

  end

end
