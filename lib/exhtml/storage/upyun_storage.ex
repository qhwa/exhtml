defmodule Exhtml.Storage.UpyunStorage do

  @moduledoc """
  UpyunStorage generater.

  Example:

      iex> %Upyun{bucket: "travis", operator: "travisci", password: "testtest"}
      ...>   |> Exhtml.Storage.UpyunStorage.setup(&("/path/to/data/#\{&1}/index.html"))
      ...>   |> apply(:fetch, ["hello"])
      {:error, :file_not_found}
  """

  defmacro setup(policy, slug_to_path) do
    quote do
      name = [unquote(policy), unquote(slug_to_path)]
        |> inspect
        |> String.to_atom

      defmodule name do

        @policy unquote(policy)

        def fetch(slug) do
          path = unquote(slug_to_path).(slug)
          Upyun.get(@policy, path)
        end

      end

      # we only need the module name
      |> elem(1)
    end
  end

end
