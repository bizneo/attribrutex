defmodule Attribrutex.ChangesetTest do
  use ExUnit.Case
  alias Attribrutex.Changeset
  alias AttribrutexUser, as: User

  @repo Attribrutex.RepoClient.repo

  setup do
    @repo.delete_all(Attribrutex.CustomField)
    :ok
  end

  test "put/3 with valid value" do
    changeset = User.changeset(%User{}, %{email: "asdf@asdf.com"})
    changeset = Changeset.put(changeset, %{key: :location, type: :string}, "Madrid")
    assert changeset.changes == %{
      custom_fields: %{location: "Madrid"},
      email: "asdf@asdf.com"
    }
  end

  test "put/3 with invalid value" do
    changeset = User.changeset(%User{}, %{email: "asdf@asdf.com"})
    changeset = Changeset.put(changeset, %{key: :salary, type: :integer}, "Madrid")
    refute changeset.valid?
  end
end
