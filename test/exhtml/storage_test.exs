defmodule Exhtml.StorageTest do
  use ExUnit.Case

  doctest Exhtml.Storage

  setup do
    {:ok, pid} = Exhtml.Storage.start_link(engine: Exhtml.Storage.TestStorage)
    {:ok, %{pid: pid}}
  end

  test "fetch content from storage", %{pid: pid} do
    assert Exhtml.Storage.fetch(pid, "foo") == "FOO"
  end
end

defmodule Exhtml.Storage.TestStorage do
  
  def fetch(slug) do
    slug
      |> to_string
      |> String.upcase
  end
end
