defmodule Exhtml.Storage do
  @moduledoc """
  Storage provides a `fetch` method used to fetch content from outside
  source.

  ## Examples:

      iex> {:ok, pid} = Exhtml.Storage.start_link []
      ...> Exhtml.Storage.fetch(pid, :foo)
      nil
      iex> # fetcher can be replaced at runtime
      ...> Exhtml.Storage.set_fetcher(pid, fn slug -> "#\{slug} is awesome" end)
      ...> Exhtml.Storage.fetch(pid, :foo)
      "foo is awesome"

  or you can start a process, passing fetcher:

      iex> fetcher = fn slug -> "#\{slug} on remote" end
      ...> {:ok, pid} = Exhtml.Storage.start_link fetcher: fetcher
      ...> Exhtml.Storage.fetch(pid, :foo)
      "foo on remote"

  """

  use GenServer

  @type slug :: Exhtml.slug()

  # APIs

  @doc false
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @doc """
  Fetches the content of a slug.

  * `pid` - the PID or name of the server process
  * `slug` - the key for the content

  Returns `nil` or the content stored.

  ## Examples:

      iex> {:ok, pid} = Exhtml.Storage.start_link [fetcher: fn slug -> "default_content_for_#\{slug}" end]
      ...> Exhtml.Storage.fetch(pid, :foo)
      "default_content_for_foo"

  """
  @spec fetch(GenServer.server(), term) :: any
  def fetch(pid, slug) do
    GenServer.call(pid, {:fetch, slug})
  end

  @doc """
  Dynamicly set content fetcher. A fetcher can be a function, or a module that can repsond to &fetch/1.
  If you want to 'unset' fetcher, just pass `nil` as fetcher.

  * `pid` - the PID or name of the server process
  * `f` - function or module to fetch the content by a slug

  Returns `:ok`.

  ## Examples:

  use a function as fetcher:

      iex> {:ok, pid} = Exhtml.Storage.start_link []
      ...> Exhtml.Storage.set_fetcher(pid, fn _slug -> :bar end)
      :ok

  or a module:

      iex> defmodule A do
      ...>   def fetch(slug), do: "Hello, #\{slug}~"
      ...> end
      ...>
      ...> {:ok, pid} = Exhtml.Storage.start_link []
      ...> Exhtml.Storage.set_fetcher(pid, A)
      :ok
      iex> Exhtml.Storage.fetch(pid, :miao)
      "Hello, miao~"

  """
  @spec set_fetcher(GenServer.server(), (slug -> any) | module) :: :ok
  def set_fetcher(pid, f) do
    GenServer.call(pid, {:set_fetcher, f})
  end

  # Callbacks

  def handle_call({:fetch, slug}, _from, state) do
    content = fetch_content(slug, state[:fetcher])
    {:reply, content, state}
  end

  def handle_call({:set_fetcher, f}, _from, state) do
    {:reply, :ok, Keyword.put(state, :fetcher, f)}
  end

  defp fetch_content(_, nil), do: nil
  defp fetch_content(slug, fetcher) when is_function(fetcher), do: fetcher.(slug)
  defp fetch_content(slug, engine) when is_atom(engine), do: apply(engine, :fetch, [slug])
end
