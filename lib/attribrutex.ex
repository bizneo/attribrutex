defmodule Attribrutex do
  @moduledoc """
  Public functions to manage custom fields
  """
  alias Attribrutex.CustomField

  @repo Attribrutex.RepoClient.repo

  @doc """
  Creates a new field for a module.

  If you need specify a context, in example, the custom field belongs
  to a specific user, you can use the opts to set a `context_id` and a
  `context_type`.

  ## Example

     Attribrutex.create_custom_field("location", :string, User)

  Now, the custom field belongs to the `User` model

  ## Context example

     Attribrutex.create_custom_field("location", :string, User, context_id: user.id, context_type: "User")

  Setting a context, you can make fields available only for an specific resource

  """
  def create_custom_field(key, type, module, opts \\ [])
  def create_custom_field(key, type, module, []) do
    attrs = %{
      key: key,
      field_type: type,
      fieldable_type: module_name(module)
    }

    insert_custom_field(attrs)
  end
  def create_custom_field(key, type, module, [context_id: context_id, context_type: context_type]) do
    attrs = %{
      key: key,
      field_type: type,
      fieldable_type: module_name(module),
      context_id: context_id,
      context_type: context_type
    }

    insert_custom_field(attrs)
  end

  defp insert_custom_field(attrs) do
    with changeset <- CustomField.changeset(%CustomField{}, attrs) do
      @repo.insert(changeset)
    end
  end

  defp module_name(module), do: module |> Module.split |> List.last
end
