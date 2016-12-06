defmodule ExhtmlTest.HostTest do
  use ExUnit.Case
  doctest Exhtml.Host
  alias Exhtml.Host

  setup do
    Host.start_link
    :ok
  end

  test "get running status" do
    assert Host.status(:foo) == :not_running
  end

  test "start a host" do
    :ok = Host.start(:foo, [])
  end

  test "get status of a host" do
    Host.start(:foo, [])
    assert Host.status(:foo) == :running
  end

  test "stop a host" do
    :ok = Host.start(:foo, [])
    Host.stop(:foo)

    assert Host.status(:foo) == :not_running
  end

  test "get content by name and slug" do
    Host.start(:foo, [])
    assert Host.get_content(:foo, :hello_page) == nil
  end

  test "set content by name and slug" do
    Host.start(:foo, [])
    Host.set_content(:foo, :hello_page, "~~~")
    assert Host.get_content(:foo, :hello_page) == "~~~"
  end

  test "fetch and set content by name and slug" do
    Host.start(:foo, storage_engine: Exhtml.Storage.TestStorage)
    Host.update_content(:foo, "some-content")

    assert Host.get_content(:foo, "some-content") == "SOME-CONTENT"
  end
end
