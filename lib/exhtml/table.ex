defmodule Exhtml.Table do
  @type slug :: Exhtml.slug()
  @type server :: GenServer.server()

  @moduledoc """
  Exhtml.Table provides a place to set and get HTML contents by slug.

  ## Examples:

      iex> {:ok, pid} = Exhtml.Table.start_link []
      ...> Exhtml.Table.set(pid, :foo, :bar)
      :ok
      ...> Exhtml.Table.get(pid, :foo)
      :bar

  """

  @repo Exhtml.Repo.Default

  use GenServer
  import Logger

  # APIs

  @doc """
  Starts a Exhtml.Table process.

  * `opts` - options for starting the process:
      * `data_dir` indicates which path the data will be persited in.
      * `data_nodes` indicates which nodes will hold persisted data. Other nodes
          will only hold data in memories.

  Returns `{:ok, pid}` if succeed, `{:error, reason}` otherwise.
  """
  @spec start_link(key: any) :: {:ok, pid} | {:error, any}
  def start_link(opts) do
    GenServer.start_link(@repo, opts)
  end

  @doc """
  Gets content of the slug from the store.

  * `server` - PID or name of the server
  * `slug` - key of the content
  """
  @spec get(server, slug) :: any
  def get(server, slug) do
    GenServer.call(server, {:get, slug})
  end

  @doc """
  Gets content of the slug from the store since the time.

  * `server` - PID or name of the server
  * `slug` - key of the content
  * `since` - modiefied time
  """
  @spec get_since(server, slug, DateTime.t()) :: any
  def get_since(server, slug, since) do
    GenServer.call(server, {:get_since, slug, since})
  end

  @doc """
  Sets content of the slug into the store.

  * `server` - PID or name of the server
  * `slug` - key of the content
  * `content` - the content for the slug

  ## Examples:

      iex> {:ok, pid} = Exhtml.Table.start_link []
      ...> Exhtml.Table.set(pid, :foo, :bar)
      :ok
      iex> Exhtml.Table.get(pid, :foo)
      :bar
      
  """
  @spec set(server, slug, any) :: :ok
  def set(server, slug, content) do
    GenServer.call(server, {:set, slug, content})
  end

  @doc """
  Removes content of the slug from the store.

  * `server` - PID or name of the server
  * `slug` - key of the content
  """
  @spec rm(server, slug) :: :ok
  def rm(server, slug) do
    GenServer.call(server, {:rm, slug})
  end

end
