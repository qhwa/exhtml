defmodule ExhtmlTest.HostTest do
  import TestHelper

  use ExUnit.Case
  doctest Exhtml.Host
  alias Exhtml.{Host, Repo}

  setup do
    Exhtml.Stash.start_link(%{}, %{})
    {:ok, repo} = Repo.start_link([])
    {:ok, pid} = Host.start_link(repo: repo)
    {:ok, %{server: pid}}
  end


  test "host process should be running", %{server: server} do
    assert Process.alive?(server)
  end


  test "get content by name and slug", %{server: server} do
    Host.delete_content(server, :hello_page)
    assert Host.get_content(server, :hello_page) == nil
  end


  test "set content by name and slug", %{server: server} do
    Host.set_content(server, :hello_page, "~~~")
    assert Host.get_content(server, :hello_page) == "~~~"
  end


  test "fetch and set content by name and slug, with default storage", %{server: server} do
    Host.update_content(server, "some-content")

    assert Host.get_content(server, "some-content") == "default_content_for_some-content"
  end


  test "fetch and set content by name and slug" do
    {:ok, repo} = Repo.start_link([])
    {:ok, server} = Host.start_link(
      content_fetcher: Exhtml.Storage.TestStorage,
      repo: repo
    )
    Host.update_content(server, "some-content")

    assert Host.get_content(server, "some-content") == "SOME-CONTENT"
  end


  test "delete content by name and slug", %{server: server} do
    Host.update_content(server, "some-content")
    Host.delete_content(server, "some-content")

    refute Host.get_content(server, "some-content")
  end

  
  test "dynamicly set content fetcher", %{server: server} do
    Host.set_content_fetcher(server, fn slug -> slug end)
    Host.update_content(server, "aye")
    assert Host.get_content(server, "aye") == "aye"
  end


  test ".get_content_since", %{server: server} do
    Host.update_content(server, "some-content")

    assert Host.get_content_since(server, "some-content", DateTime.utc_now) == :unchanged
    assert Host.get_content_since(server, "some-content", nil) == {:ok, "default_content_for_some-content"}
    assert Host.get_content_since(server, "some-content", yesterday()) == {:ok, "default_content_for_some-content"}
  end

  test "should not save content to table when fetched content is invalid", %{server: server} do
    assert Host.set_content(server, :foo_err, {:error, :bar}) == {:error, :bar}
    assert Host.get_content(server, :foo_err) == nil
    assert Host.get_content_since(server, :foo_err, nil) == nil
  end


  test "should not update content when fetche content is invalid" do
    {:ok, repo} = Repo.start_link([])
    {:ok, pid} = Host.start_link([
      content_fetcher: fn _ -> {:error, :invalid} end,
      repo: repo
    ])
    assert Host.update_content(pid, :foo_err_update) == {:error, :invalid}
    assert Host.get_content_since(pid, :foo_err_update, nil) == nil
  end
end
