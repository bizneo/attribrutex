defmodule Repo.Migrations.AddCustomFieldsTousers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :custom_fields, :jsonb, null: false
    end

    create index(:users, [:custom_fields], using: "gin")
  end
end
