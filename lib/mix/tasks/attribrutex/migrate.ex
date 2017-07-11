defmodule Mix.Tasks.Attribrutex.Migrate do
  @shortdoc "generates Attribrutex migration file for models"

  use Mix.Task
  import Mix.Generator
  import Mix.Tasks.Attribrutex.Utils, only: [timestamp: 0]

  def run(args) do
    table = Enum.at(args, 0)
    path = Path.relative_to("priv/repo/migrations", Mix.Project.app_path)
    file = Path.join(path, "#{timestamp()}_add_custom_fields_to_#{table}.exs")
    create_directory path

    create_file file, """
    defmodule Repo.Migrations.AddCustomFieldsTo#{table} do
      use Ecto.Migration

      def change do
        alter table(:#{table}) do
          add :custom_fields, :jsonb
        end

        create index(:#{table}, [:custom_fields], using: "gin")
      end
    end
    """
  end

end
