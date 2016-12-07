defmodule Exhtml.Storage.UpyunStorage do

  def setup(policy) do
    "UpyunStorage_#{inspect policy}"
      |> String.to_atom
      |> to_custom_module(policy)
  end


  defp to_custom_module(name, policy) do
    {:module, name, _, _} = defmodule name do
      @policy policy
      
      def fetch(slug) do
        Upyun.get(@policy, slug)
      end

    end

    name
  end

  
end
