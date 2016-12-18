defmodule ExhtmlTest.StashTest do

  use ExUnit.Case
  doctest Exhtml.Stash
  alias Exhtml.Stash

  setup do
    {:ok, pid} = Stash.start_link %{a: 1}, name: :exhtml_stash_test
    {:ok, %{pid: pid}}
  end


  test ".registry_state", %{pid: pid} do
    assert Stash.registry_state(pid) == %{a: 1}
  end


  test ".save_registry", %{pid: pid} do
    state = %{b: 2}
    Stash.save_registry(pid, state)

    assert Stash.registry_state(pid) == state
  end


end
