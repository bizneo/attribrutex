defmodule Mix.Tasks.Attribrutex.Install do
  @shortdoc "generates Attribrutex migration file for the database"

  use Mix.Task
  import Mix.Generator
  import Mix.Tasks.Attribrutex.Utils, only: [timestamp: 0]

  def run(_args) do
    path = Path.relative_to("priv/repo/migrations", Mix.Project.app_path)
    file = Path.join(path, "#{timestamp()}_create_custom_field.exs")
    create_directory path

    create_file file, """
    defmodule Repo.Migrations.CreateCustomField do
      use Ecto.Migration

      def change do
        create table(:custom_fields) do
          add :key, :string, null: false
          add :field_type, :integer, null: false, default: 0
          add :fieldable_type, :string, null: false

          add :inserted_at,  :utc_datetime, null: false
          add :updated_at,  :utc_datetime, null: false
        end

        create unique_index(:custom_fields, [:key, :fieldable_type], name: :custom_fields_unique_field)
      end
    end
    """
  end
end
