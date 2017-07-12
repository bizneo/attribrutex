Mix.Task.run "ecto.create", ~w(-r Attribrutex.Repo)
Mix.Task.run "ecto.migrate", ~w(-r Attribrutex.Repo)

Attribrutex.Repo.start_link

ExUnit.start()
