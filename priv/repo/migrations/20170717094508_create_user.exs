defmodule Repo.Migrations.CreateCustomField do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false

      add :inserted_at,  :utc_datetime, null: false
      add :updated_at,  :utc_datetime, null: false
    end
  end
end
