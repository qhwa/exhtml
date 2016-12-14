defmodule Exhtml.RegistryTest do
  use ExUnit.Case

  alias Exhtml.Registry
  doctest Registry

  setup do
    Exhtml.Stash.start_link %{a: 1}, %{}
    Registry.start_link
    :ok
  end

  test ".register a string" do
    Registry.register(:exhtml_host, "test")
    assert Registry.whereis(:exhtml_host) == "test"
  end

  test "register a pid" do
    Registry.register(:registry_store, GenServer.whereis(:registry))
    assert GenServer.whereis(:registry) == Registry.whereis(:registry_store)
  end

  test "recover from the stash" do
    assert Registry.whereis(:a) == 1
  end
end
