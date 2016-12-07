defmodule ExhtmlTest.Storage.UpyunStorageTest do
  use ExUnit.Case
  alias Exhtml.Storage.UpyunStorage
  doctest UpyunStorage

  @policy %Upyun{bucket: "travis", operator: "travisci", password: "testtest"}
  @module UpyunStorage.setup(@policy)

  setup do
    HTTPoison.start

    n = :rand.uniform(10000)
    path = "/test-#{n}.txt"

    on_exit fn ->
      Upyun.delete(@policy, path)
    end

    {:ok, %{path: path}}
  end

  test ".fetch", %{path: path} do
    @policy |> Upyun.put("~hello~", path)
    assert apply(@module, :fetch, [path]) == "~hello~"
  end
end
