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
    changeset = Changeset.put(changeset, %{key: :location, value: "Madrid", type: :string})
    assert changeset.changes == %{
      custom_fields: %{location: "Madrid"},
      email: "asdf@asdf.com"
    }
  end

  test "put/3 with invalid value" do
    changeset = User.changeset(%User{}, %{email: "asdf@asdf.com"})
    changeset = Changeset.put(changeset, %{key: :salary, value: "Madrid", type: :integer})
    refute changeset.valid?
  end

  test "put/3 with integer value" do
    changeset = User.changeset(%User{}, %{email: "asdf@asdf.com"})
    changeset = Changeset.put(changeset, %{key: :salary, value: 50_000, type: :integer})
    assert changeset.changes == %{
      custom_fields: %{salary: 50_000},
      email: "asdf@asdf.com"
    }
  end

  test "put/3 with boolean value" do
    changeset = User.changeset(%User{}, %{email: "asdf@asdf.com"})
    changeset = Changeset.put(changeset, %{key: :active, value: true, type: :boolean})
    assert changeset.changes == %{
      custom_fields: %{active: true},
      email: "asdf@asdf.com"
    }
  end

  test "put/3 with float value" do
    changeset = User.changeset(%User{}, %{email: "asdf@asdf.com"})
    changeset = Changeset.put(changeset, %{key: :salary, value: 50.22, type: :float})
    assert changeset.changes == %{
      custom_fields: %{salary: 50.22},
      email: "asdf@asdf.com"
    }
  end
end
