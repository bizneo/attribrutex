defmodule Attribrutex.Changeset do
  @moduledoc """
  Contains the functions to manage changes on changeset
  """

  @doc """
  Passing a changeset and a struct with `:key`, `:value` and `:type`
  will try to add to the changeset changes.

  If the given value doesn't match with the type, an error will be
  added to changeset errors.
  """
  @spec put(Ecto.Changeset.t, map) :: Ecto.Changeset.t
  def put(changeset, %{key: key, value: value, type: type}) do
    value
    |> validate(type)
    |> manage_value(changeset, key, value)
  end

  defp validate(value, :boolean), do: is_boolean(value)
  defp validate(value, :integer), do: is_integer(value)
  defp validate(value, :string), do: is_bitstring(value)
  defp validate(value, :float), do: is_float(value)

  defp manage_value(false, changeset, key, _value) do
    Ecto.Changeset.add_error(changeset, :custom_fields, "Bad data type", custom_field: key)
  end
  defp manage_value(true, changeset, key, value) do
    with custom_fields <- custom_fields_changes(changeset, key, value),
         changes <- Map.put(changeset.changes, :custom_fields, custom_fields)
    do
      Map.put(changeset, :changes, changes)
    end
  end

  defp custom_fields_changes(changeset, key, value) do
    changeset
    |> fetch_custom_fields
    |> Map.put(key, value)
  end

  defp fetch_custom_fields(changeset), do: changeset.data.custom_fields || %{}
end
