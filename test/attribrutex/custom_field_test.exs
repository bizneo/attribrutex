defmodule Attribrutex.CustomFieldTest do
  use ExUnit.Case
  alias Attribrutex.CustomField

  doctest Attribrutex

  @repo Attribrutex.RepoClient.repo

  @valid_attrs %{key: "field", field_type: :string, fieldable_type: "User"}

  setup do
    @repo.delete_all(CustomField)
    :ok
  end

  test "changeset with valid attributes" do
    changeset = CustomField.changeset(%CustomField{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CustomField.changeset(%CustomField{}, %{})
    refute changeset.valid?
  end

  test "changeset with repeated field" do
    @repo.insert(CustomField.changeset(%CustomField{}, @valid_attrs))

    {status, _} = @repo.insert(CustomField.changeset(%CustomField{}, @valid_attrs))

    assert status == :error
  end
end
