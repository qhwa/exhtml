defmodule Exhtml.Storage.TestStorage do
  
  def fetch(slug) do
    slug
      |> to_string
      |> String.upcase
  end
end

defmodule TestHelper do
  def yesterday do
    now = DateTime.utc_now
      |> DateTime.to_unix
    t = now - 24 * 3600
    t |> DateTime.from_unix!
  end
end

Supervisor.stop(Exhtml.App)
ExUnit.start()
