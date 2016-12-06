defmodule ExhtmlTest.HostTest do
  use ExUnit.Case
  doctest Exhtml.Host
  alias Exhtml.Host

  setup do
    {:ok, pid} = Host.start
    {:ok, %{server: pid}}
  end


  test "host process should be running", %{server: server} do
    assert Process.alive?(server)
  end


  test "get content by name and slug", %{server: server} do
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
    {:ok, server} = Host.start(storage_engine: Exhtml.Storage.TestStorage)
    Host.update_content(server, "some-content")

    assert Host.get_content(server, "some-content") == "SOME-CONTENT"
  end
end
