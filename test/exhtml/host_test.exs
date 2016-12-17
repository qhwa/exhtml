defmodule ExhtmlTest.HostTest do
  use ExUnit.Case
  doctest Exhtml.Host
  alias Exhtml.Host

  setup do
    Exhtml.Stash.start_link(%{}, %{})
    {:ok, pid} = Host.start_link([])
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
    {:ok, server} = Host.start_link(content_fetcher: Exhtml.Storage.TestStorage)
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
end
