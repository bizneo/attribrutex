defmodule AttribrutexUser do
  use Ecto.Schema
  use Attribrutex.Model
  import Ecto.Changeset

  schema "posts" do
    field :email, :string
    field :custom_fields, :map

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
  end
end

