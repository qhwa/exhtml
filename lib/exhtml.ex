defmodule Exhtml do

  use Application

  @moduledoc """
  Exhtml serves HTML contents.
  It fetches content from backend storage and saves in
  its state. HTML contents are responded to user directly
  from state.
  """

  @name {:global, :exhtml_host}

  @doc """
  Sets the content fetcher.
  """
  def set_content_fetcher(f) do
    Exhtml.Host.set_content_fetcher(@name, f)
  end

  @doc """
  Gets html content from a host.
  """
  def get_content(slug) do
    Exhtml.Host.get_content(@name, slug)
  end


  @doc """
  Sets html content to a host with a slug.
  """
  def set_content(slug, value) do
    Exhtml.Host.set_content(@name, slug, value)
  end


  @doc """
  Fetchs and sets the content from the storage to a host's table.
  """
  def update_content(slug) do
    Exhtml.Host.update_content(@name, slug)
  end


  @doc """
  Deletes the content from a host.
  """
  def delete_content(slug) do
    Exhtml.Host.delete_content(@name, slug)
  end

end
