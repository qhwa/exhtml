defmodule ExhtmlTest.Storage.UpyunStorageTest do
  use ExUnit.Case
  alias Exhtml.Storage.UpyunStorage
  doctest UpyunStorage

  require UpyunStorage

  setup do
    HTTPoison.start

    policy = %Upyun{bucket: "travis", operator: "travisci", password: "testtest"}
    n      = :rand.uniform(10000)
    path   = "/test-#{n}.txt"
    module = UpyunStorage.setup(policy, &ExhtmlTest.Storage.UpyunStorageTest.upyun_path/1)

    on_exit fn -> Upyun.delete(policy, upyun_path(path)) end

    {:ok, %{path: path, module: module, policy: policy}}
  end

  test ".fetch", %{path: path, module: module, policy: policy} do
    content = "~HELLO~"
    Upyun.put(policy, content, upyun_path(path))
    assert apply(module, :fetch, [path]) == content
  end

  def upyun_path(slug) do
    "/test" <> slug
  end

end
