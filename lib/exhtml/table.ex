defmodule Exhtml.Table do
  
  @moduledoc """
  Exhtml.Table is a group of HTML contents.
  """

  @table_name_in_db :exhtml_contents

  use GenServer

  # APIs

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  def get(ns, slug) do
    GenServer.call(ns, {:get, slug})
  end

  def set(ns, slug, content) do
    GenServer.call(ns, {:set, slug, content})
  end

  def rm(ns, slug) do
    GenServer.call(ns, {:rm, slug})
  end


  # Callbacks

  def init(opts) do
    start_db(opts[:data_dir] || "./exhtml_contents")
    {:ok, %{}}
  end

  defp start_db(data_dir) do
    :mnesia |> :application.load
    :mnesia |> :application.set_env(:dir, to_charlist(data_dir))
    :mnesia.create_schema([node])
    :mnesia.start
    :mnesia.create_table @table_name_in_db, attributes: [:slug, :content], disc_copies: [node]
    :mnesia.wait_for_tables [@table_name_in_db], 5000
  end

  def handle_call({:get, slug}, _from, state) do
    ret = slug
      |> db_result
      |> db_to_val

    {:reply, ret, state}
  end

  def handle_call({:set, slug, content}, _from, state) do
    {:atomic, _} = :mnesia.transaction(fn ->
      :mnesia.write(@table_name_in_db, {@table_name_in_db, slug, content}, :write)
    end)
    {:reply, :ok, state}
  end

  def handle_call({:rm, slug}, _from, state) do
    {:atomic, _} = :mnesia.transaction(fn ->
      :mnesia.delete(@table_name_in_db, slug, :write)
    end)
    {:reply, :ok, state}
  end

  defp db_result(slug) do
    @table_name_in_db |> :mnesia.dirty_read(slug) |> List.first
  end

  defp db_to_val(nil) do
    nil
  end

  defp db_to_val({@table_name_in_db, _slug, content}) do
    content
  end

end
