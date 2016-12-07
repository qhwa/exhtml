defmodule ExhtmlTest.Storage.DefaultStorageTest do
  use ExUnit.Case
  doctest Exhtml.Storage.DefaultStorage

  test ".fetch" do
    assert Exhtml.Storage.DefaultStorage.fetch("aa") == "default_content_for_aa"
  end
end
