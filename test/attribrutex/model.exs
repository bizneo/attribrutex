defmodule Attribrutex.ModelTest do
  use ExUnit.Case
  alias Attribrutex.CustomField
  alias AttribrutexUser, as: User

  doctest Attribrutex

  @repo Attribrutex.RepoClient.repo

  @valid_attrs %{key: "field", field_type: :string}

  setup do
    @repo.delete_all(CustomField)
    @repo.delete_all(User)
    :ok
  end

  test "custom_field_changeset with valid attributes" do
    {status, _} = @repo.insert(User.custom_field_changeset(@valid_attrs))

    assert status == :ok
    assert @repo.aggregate(CustomField, :count) == 1
  end

  test "custom_field_changeset with invalid attributes" do
    {status, _} = @repo.insert(User.custom_field_changeset(%{}))

    assert status == :error
    assert @repo.aggregate(CustomField, :count) == 0
  end

  test "custom_field_changeset with repeated field" do
    @repo.insert(User.custom_field_changeset(@valid_attrs))

    {status, _} = @repo.insert(User.custom_field_changeset(@valid_attrs))

    assert status == :error
  end
end
