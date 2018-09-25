defmodule ExhtmlTest do
  use ExUnit.Case
  doctest Exhtml

  test "error is returned when interacting with exhtml without a repo started" do
    Exhtml.start(auto_start_repo: false)
    assert Exhtml.get_content(:foo) == {:error, :repo_not_started}
  end
end
