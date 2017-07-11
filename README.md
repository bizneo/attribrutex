# Attribrutex
Configure custom fields dynamically on your Phoenix models

## Installation

  1. Add `attribrutex` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:attribrutex, "~> 0.1.0"}]
  end
  ```

  2. Configure Attribrutex to use your repo in `config/config.exs`:

  ```elixir
  config :Attribrutex, repo: ApplicationName.Repo
  ```

  3. Install your dependencies:

  ```mix deps.get```

  4. Generate the migrations:

  ```mix taglet.install```

  5. Run the migrations:

  ```mix ecto.migrate```

