defmodule Exhtml.RegistryTest do
  use ExUnit.Case

  alias Exhtml.Registry
  doctest Registry

  setup do
    Registry.start
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
end
