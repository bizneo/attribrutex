defmodule Attribrutex.RepoClient do
  @moduledoc """
  All functions related with configuring database access
  """

  @doc """
  Gets the configured repo module or defaults to Repo if none configured
  """
  def repo, do: Application.get_env(:attribrutex, :repo, Repo)
end
