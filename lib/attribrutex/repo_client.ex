defmodule Attribrutex.RepoClient do
  @doc """
  Gets the configured repo module or defaults to Repo if none configured
  """
  def repo, do: Application.get_env(:attribrutex, :repo, Repo)
end
