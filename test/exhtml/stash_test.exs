defmodule ExhtmlTest.StashTest do

  use ExUnit.Case
  doctest Exhtml.Stash
  alias Exhtml.Stash

  setup do
    Stash.start_link %{a: 1}, %{"hi" => "there"}
    :ok
  end


  test ".registry_state" do
    assert Stash.registry_state == %{a: 1}
  end


  test ".table_state" do
    assert Stash.table_state == %{"hi" => "there"}
  end


  test ".save_registry" do
    state = %{b: 2}
    Stash.save_registry state

    assert Stash.registry_state == state
  end


  @tag underview: true
  test ".save_table" do
    state = %{"hi" => "not there"}
    Stash.save_table state

    assert Stash.table_state == state
  end

end
