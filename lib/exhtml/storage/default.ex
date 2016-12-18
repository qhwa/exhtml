defmodule Exhtml.Storage.DefaultStorage do
  
  @moduledoc """
  Default empty storage.
  """

  @doc """
  Returns default content for `slug` which is determinated.

  * `slug` is a key to fetch content with.

  ## Examples:

      iex> Exhtml.Storage.DefaultStorage.fetch(:foo)
      "default_content_for_foo"

  """
  @spec fetch(Exhtml.slug) :: binary
  def fetch(slug) do
    "default_content_for_#{slug}"
  end

end
