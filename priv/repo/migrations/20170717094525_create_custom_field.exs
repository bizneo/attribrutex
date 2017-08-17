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

    create unique_index(:custom_fields, [:key, :fieldable_type, :context_id, :context_type], where: "context_id IS NOT NULL AND context_type IS NOT NULL", name: :custom_fields_unique_index)
    create unique_index(:custom_fields, [:key, :fieldable_type, :context_id], where: "context_id IS NOT NULL AND context_type IS NULL", name: :custom_fields_unique_index_no_context_id)
    create unique_index(:custom_fields, [:key, :fieldable_type, :context_type], where: "context_id IS NULL AND context_type IS NOT NULL", name: :custom_fields_unique_index_no_context_type)
    create unique_index(:custom_fields, [:key, :fieldable_type], where: "context_id IS NULL AND context_type IS NULL", name: :custom_fields_unique_index_only_fieldable_type)
  end
end
