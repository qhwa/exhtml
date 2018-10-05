defmodule ExhtmlTest.Storage.DefaultStorageTest do
  use ExUnit.Case

  alias Exhtml.Storage.DefaultStorage
  doctest DefaultStorage

  test ".fetch" do
    assert DefaultStorage.fetch("aa") == "default_content_for_aa"
  end
end
