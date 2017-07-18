defmodule AttribrutexUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :custom_fields, :map, default: %{}

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
  end

  def custom_fields_changeset(struct, params \\ %{}, opts \\ %{}) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
    |> Attribrutex.prepare_custom_fields(params, opts)
  end
end
