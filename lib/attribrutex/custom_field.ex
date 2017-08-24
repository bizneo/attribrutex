defmodule Attribrutex.CustomField do
  @moduledoc """
  This module modelate the table for created custom fields
  """

  use Ecto.Schema

  import Ecto.Changeset
  import EctoEnum, only: [defenum: 2]

  defenum FieldTypeEnum,
    string:   0,
    integer:  1,
    float:    2

  schema "custom_fields" do
    field :key, :string, null: false
    field :field_type, FieldTypeEnum, null: false, default: :string
    field :fieldable_type, :string, null: false
    field :context_id, :integer
    field :context_type, :string

    timestamps()
  end

  @custom_field_params [:key, :field_type, :fieldable_type,
    :context_id, :context_type]
  @required_custom_field_params [:key, :field_type, :fieldable_type]

  @doc """
  This function allows to add new entries to the table and validate
  that keys are not repeated for a model or for a model and context
  if it exists
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @custom_field_params)
    |> validate_required(@required_custom_field_params)
    |> unique_constraint(:key, name: :custom_fields_unique_index)
    |> unique_constraint(:key, name: :custom_fields_unique_index_no_context_id)
    |> unique_constraint(:key, name: :custom_fields_unique_index_no_context_type)
    |> unique_constraint(:key, name: :custom_fields_unique_index_only_fieldable_type)
  end
end
