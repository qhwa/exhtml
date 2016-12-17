defmodule ExhtmlTest.StashTest do

  use ExUnit.Case
  doctest Exhtml.Stash
  alias Exhtml.Stash

  setup do
    {:ok, pid} = Stash.start_link %{a: 1}, %{"hi" => "there"}, name: :exhtml_stash_test
    {:ok, %{pid: pid}}
  end


  test ".registry_state", %{pid: pid} do
    assert Stash.registry_state(pid) == %{a: 1}
  end


  test ".table_state", %{pid: pid} do
    assert Stash.table_state(pid) == %{"hi" => "there"}
  end


  test ".save_registry", %{pid: pid} do
    state = %{b: 2}
    Stash.save_registry(pid, state)

    assert Stash.registry_state(pid) == state
  end


  @tag underview: true
  test ".save_table", %{pid: pid} do
    state = %{"hi" => "not there"}
    Stash.save_table pid, state

    assert Stash.table_state(pid) == state
  end

end
