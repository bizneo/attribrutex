defmodule Attribrutex.Model do
  defmacro __using__([]) do
    quote do
      def unquote(:custom_field_changeset)(params) do
        params = Map.put(params, :fieldable_type, module_to_string(__MODULE__))

        Attribrutex.CustomField.changeset(%Attribrutex.CustomField{}, params)
      end

      defp module_to_string(module), do: module |> Module.split |> List.last
    end
  end
end
