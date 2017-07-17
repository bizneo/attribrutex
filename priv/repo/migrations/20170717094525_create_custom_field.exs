defmodule Repo.Migrations.CreateCustomField do
  use Ecto.Migration

  def change do
    create table(:custom_fields) do
      add :key, :string, null: false
      add :field_type, :integer, null: false, default: 0
      add :fieldable_type, :string, null: false
      add :context_id, :integer
      add :context_type, :string

      add :inserted_at,  :utc_datetime, null: false
      add :updated_at,  :utc_datetime, null: false
    end

    execute "CREATE UNIQUE INDEX custom_fields_unique_index ON custom_fields (key, fieldable_type, context_id, context_type) WHERE context_id IS NOT NULL AND context_type IS NOT NULL;"
    execute "CREATE UNIQUE INDEX custom_fields_unique_index_no_context_id ON custom_fields (key, fieldable_type, context_id) WHERE context_id IS NOT NULL AND context_type IS NULL;"
    execute "CREATE UNIQUE INDEX custom_fields_unique_index_no_context_type ON custom_fields (key, fieldable_type, context_type) WHERE context_id IS NULL AND context_type IS NOT NULL;"
    execute "CREATE UNIQUE INDEX custom_fields_unique_index_only_fieldable_type ON custom_fields (key, fieldable_type) WHERE context_id IS NULL AND context_type IS NULL;"
  end
end
