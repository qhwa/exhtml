defmodule Exhtml do

  @moduledoc """
  Exhtml serves HTML contents.
  It fetches content from backend storage and saves in
  its state. HTML contents are responded to user directly
  from state.
  """

  @doc """
  Gets html content from a host.
  """
  def get_content(slug) do
    Exhtml.Host.get_content(:exhtml_host, slug)
  end


  @doc """
  Sets html content to a host with a slug.
  """
  def set_content(slug, value) do
    Exhtml.Host.set_content(:exhtml_host, slug, value)
  end


  @doc """
  Fetchs and sets the content from the storage to a host's table.
  """
  def update_content(slug) do
    Exhtml.Host.update_content(:exhtml_host, slug)
  end


  @doc """
  Deletes the content from a host.
  """
  def delete_content(slug) do
    Exhtml.Host.delete_content(:exhtml_host, slug)
  end



end
