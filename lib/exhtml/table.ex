defmodule Exhtml.Table do

  @type slug :: Exhtml.slug
  @type server :: GenServer.server
  
  @moduledoc """
  Exhtml.Table provides a place to set and get HTML contents by slug.

  ## Examples:
  
      iex> {:ok, pid} = Exhtml.Table.start_link []
      ...> Exhtml.Table.set(pid, :foo, :bar)
      :ok
      ...> Exhtml.Table.get(pid, :foo)
      :bar

  """

  use GenServer
  alias Exhtml.Repo

  # APIs

  @doc """
  Starts a Exhtml.Table process.

  * `opts` - options for starting the process:
    * `repo` - the pid of started Exhtml.Repo server.
      If unprovided, all request to Exhtml.Table will return `{:error, :repo_not_started}`
  Returns `{:ok, pid}` if succeed, `{:error, reason}` otherwise.
  """
  @spec start_link([key: any]) :: {:ok, pid} | {:error, any}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end


  @doc """
  Start the repo engine.
  
  Before starting a repo, all actions will not be performed and
  `{:error, :repo_not_started}` will be returned.

  * `server` - PID or name of the server
  * `opts` - options to start the repo, will be passed to `Exhtml.Repo.start_link/1`
  """
  @spec start_repo(server, [key: any]) :: :ok | {:error, any}
  def start_repo(server, opts) do
    GenServer.call(server, {:start_repo, opts})
  end


  @doc """
  Join an existing repo.

  * `server` - PID or name of the server
  * `remote` - the remote node to connect and join
  * `opts` - options to start the repo, will be passed to `Exhtml.Repo.start_link/1`
  """
  @spec join_repo(server, node, [key: any]) :: :ok | {:error, any}
  def join_repo(server, remote, opts) do
    GenServer.call(server, {:join_repo, remote, opts})
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
  @spec get_since(server, slug, DateTime.t) :: any
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


  # Callbacks

  @doc false
  def init(opts) do
    case {opts[:repo], opts[:master]} do
      {repo, _} when is_pid(repo) ->
        {:ok, %{repo: repo}}

      {nil, true} ->
        {:ok, repo} = Repo.start_link(opts)
        {:ok, %{repo: repo}}

      {nil, false} ->
        {:ok, %{repo: nil}}

      {nil, n} when is_atom(n) ->
        {:ok, repo} = Repo.join(n, opts)
        {:ok, %{repo: repo}}

      {nil, _} ->
        {:ok, %{repo: nil}}

    end
  end

  def handle_call({:start_repo, opts}, _from, state) do
    {:ok, repo} = Repo.start_link(opts)
    {:reply, :ok, Map.put(state, :repo, repo)}
  end

  def handle_call({:join_repo, remote, opts}, _from, state) do
    {:ok, repo} = Repo.join(remote, opts)
    {:reply, :ok, Map.put(state, :repo, repo)}
  end

  def handle_call(_, _from, state = %{repo: nil}), do: {:reply, {:error, :repo_not_started}, state}

  def handle_call({:get, slug}, _from, state = %{repo: repo}) do
    {:reply, Repo.get(repo, slug), state}
  end

  def handle_call({:get_since, slug, since}, _from, state = %{repo: repo}) do
    {:reply, Repo.get_since(repo, slug, since), state}
  end

  def handle_call({:set, slug, content}, _from, state = %{repo: repo}) do
    {:reply, Repo.set(repo, slug, content), state}
  end

  def handle_call({:rm, slug}, _from, state = %{repo: repo}) do
    {:reply, Repo.rm(repo, slug), state}
  end
end
