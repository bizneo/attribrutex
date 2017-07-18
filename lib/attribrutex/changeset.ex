defmodule Attribrutex.Changeset do
  def put(changeset, %{key: key, value: value, type: type}) do
    value
    |> validate(type)
    |> manage_value(changeset, key, value)
  end

  defp validate(value, :string), do: is_bitstring(value)
  defp validate(value, :integer), do: is_integer(value)

  defp manage_value(valid?, changeset, key, value)
  defp manage_value(false, changeset, key, value) do
    Ecto.Changeset.add_error(changeset, :custom_fields, "Bad data type", custom_field: key)
  end
  defp manage_value(true, changeset, key, value) do
    with custom_fields <- custom_fields_changes(changeset, key, value),
         changes <- Map.put(changeset.changes, :custom_fields, custom_fields),
         changeset <- Map.put(changeset, :changes, changes)
    do
      changeset
    end
  end

  defp custom_fields_changes(changeset, key, value) do
    changeset
    |> fetch_custom_fields
    |> Map.put(key, value)
  end

  defp fetch_custom_fields(changeset), do: changeset.data.custom_fields || %{}
end
