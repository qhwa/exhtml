defmodule Exhtml.Storage.TestStorage do
  
  def fetch(slug) do
    slug
      |> to_string
      |> String.upcase
  end
end
