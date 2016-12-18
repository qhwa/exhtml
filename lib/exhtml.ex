defmodule Exhtml do

  @type slug :: binary | atom

  @moduledoc """
  Exhtml serves HTML contents.
  It fetches content from backend storage and saves in
  its state. HTML contents are responded to user directly
  from state.

  ## Examples:

      iex> Exhtml.start []
      ...> #update
      ...> Exhtml.update_content(:foo)
      "default_content_for_foo"
      iex> # get
      ...> Exhtml.get_content(:foo)
      "default_content_for_foo"

  """

  @name {:global, :exhtml_host}


  @doc """
  Starts exhtml application.
  You don't need to call this manualy if already
  put `:exhtml` in your `application` of `Mix.exs`.
  """
  @spec start([key: any]) :: {:ok, pid} | {:error, any}
  def start(opts) do
    opts
    |> Keyword.put(:name, @name)
    |> Exhtml.Host.start_link
  end


  @doc """
  Sets the content fetcher.
  A content fetcher is used when `Exhtml.update_content/1` is called.
  You can pass a function or module as content fetcher.

  Returns `:ok`.

  ## Examples:
  
      iex> Exhtml.start []
      ...> Exhtml.set_content_fetcher(fn slug -> "Hi, #\{slug}!" end)
      :ok
      iex> Exhtml.update_content(:foo)
      "Hi, foo!"
      iex> Exhtml.get_content(:foo)
      "Hi, foo!"
  """
  @spec set_content_fetcher((slug -> any) | module) :: :ok
  def set_content_fetcher(f) do
    Exhtml.Host.set_content_fetcher(@name, f)
  end


  @doc """
  Gets html content from a host.

  * `slug` is the key of content to get.

  ## Examples:

      iex> Exhtml.start []
      ...> Exhtml.set_content(:foo, :bar)
      ...> Exhtml.get_content(:foo)
      :bar

  """
  @spec get_content(slug) :: any
  def get_content(slug) do
    Exhtml.Host.get_content(@name, slug)
  end


  @doc """
  Sets html content to a host with a slug.

  * `slug` is the key of content.
  * `value` is the content.

  Returns `:ok`.

  ## Examples:

      iex> Exhtml.start []
      ...> Exhtml.set_content(:foo, :bar)
      ...> Exhtml.get_content(:foo)
      :bar

  """
  @spec set_content(slug, any) :: :ok
  def set_content(slug, value) do
    Exhtml.Host.set_content(@name, slug, value)
  end


  @doc """
  Fetchs and sets the content from the storage to a host's table.

  * `slug` is the key of content.

  Returns anything returned by the fetcher.

  ## Examples:

      iex> Exhtml.start []
      ...> Exhtml.set_content_fetcher fn slug -> "Hi, #\{slug}!" end
      ...> Exhtml.update_content :wuliu
      "Hi, wuliu!"

  """
  def update_content(slug) do
    Exhtml.Host.update_content(@name, slug)
  end


  @doc """
  Deletes the content from a host.

  * `slug` is the key of content.

  Returns `:ok`.

  ## Examples:

      iex> Exhtml.start []
      ...> Exhtml.set_content :foo, :bar
      ...> Exhtml.get_content :foo
      :bar
      iex> Exhtml.delete_content :foo
      :ok
      iex> Exhtml.get_content :foo
      nil

  """
  def delete_content(slug) do
    Exhtml.Host.delete_content(@name, slug)
  end

end
