defmodule Exhtml.Storage.DefaultStorage do
  
  @moduledoc """
  Default empty storage
  """

  def fetch(slug) do
    "default_content_for_#{slug}"
  end

end
