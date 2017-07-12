use Mix.Config

config :attribrutex, ecto_repos: [Attribrutex.Repo]

config :attribrutex, repo: Attribrutex.Repo

config :attribrutex, Attribrutex.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "ubuntu",
  password: "postgres",
  database: "attribrutex_test",
  hostname: "localhost",
  poolsize: 10
