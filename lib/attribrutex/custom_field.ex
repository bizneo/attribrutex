defmodule Attribrutex.CustomField do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoEnum, only: [defenum: 2]

  defenum FieldTypeEnum, string: 0, integer: 1

  schema "custom_fields" do
    field :key, :string, null: false
    field :field_type, FieldTypeEnum, null: false, default: :string
    field :fieldable_type, :string, null: false

    timestamps()
  end

  @custom_field_params [:key, :field_type, :fieldable_type]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @custom_field_params)
    |> validate_required(@custom_field_params)
    |> unique_constraint(:key, name: :custom_fields_unique_field)
  end
end
