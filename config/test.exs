use Mix.Config

config :logger, level: :info

config :attribrutex, ecto_repos: [Attribrutex.Repo]

config :attribrutex, repo: Attribrutex.Repo

config :attribrutex, Attribrutex.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "attribrutex_test",
  hostname: "db",
  poolsize: 10
