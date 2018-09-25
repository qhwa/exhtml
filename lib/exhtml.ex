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

  @name :exhtml_host


  @doc false
  def start(opts) do
    opts
    |> Keyword.put(:name, @name)
    |> Exhtml.Host.start_link
  end


  @doc """
  Start the repo engine. Before starting a repo, all actions will not be performed and
  `{:error, :repo_not_started}` will be returned.
  """
  def start_repo(opts) do
    Exhtml.Host.start_repo(@name, opts)
  end


  @doc """
  Join an existing exhtml cluster.

  * `node` - the node to connect
  * `opts` - options to start this repo node, including:
    * `data_dir` - where to store db datas, `./exhtml_contents` by default.
    * `data_nodes` - which nodes are used to copy datas, `[node()]` by default.
  """
  def join_repo(node, opts) do
    Exhtml.Host.join_repo(@name, node, opts)
  end


  @doc """
  Sets the content fetcher.
  A content fetcher is used when `Exhtml.update_content/1` is called.
  You can pass a function or module as content fetcher.

  Returns `:ok`.

  ## Examples:
  
      iex> Exhtml.start []
      ...> Exhtml.start_repo []
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
      ...> Exhtml.start_repo([])
      ...> Exhtml.set_content(:foo, :bar)
      ...> Exhtml.get_content(:foo)
      :bar

  """
  @spec get_content(slug) :: any
  def get_content(slug) do
    Exhtml.Host.get_content(@name, slug)
  end
  

  @doc """
  Gets html content from a host.

  * `slug` is the key of content to get.
  * `time` is the modified time.

  ## Returns:

  `{:not_modified}` - If the content has not changed since the time;
  content - if the content has changed since the time.
  """
  @spec get_content_since(slug, DateTime.t) :: any
  def get_content_since(slug, time) do
    Exhtml.Host.get_content_since(@name, slug, time)
  end


  @doc """
  Sets html content to a host with a slug.

  * `slug` is the key of content.
  * `value` is the content.

  Returns `:ok`.

  ## Examples:

      iex> Exhtml.start []
      ...> Exhtml.start_repo([])
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
      ...> Exhtml.start_repo([])
      ...> Exhtml.set_content_fetcher fn slug -> "Hi, #\{slug}!" end
      ...> Exhtml.update_content :wuliu
      "Hi, wuliu!"

  """
  @spec update_content(slug) :: any
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
  @spec delete_content(slug) :: :ok
  def delete_content(slug) do
    Exhtml.Host.delete_content(@name, slug)
  end

end
