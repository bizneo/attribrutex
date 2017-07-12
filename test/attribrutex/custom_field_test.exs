defmodule Attribrutex.CustomFieldTest do
  use ExUnit.Case
  alias Attribrutex.CustomField

  doctest Attribrutex

  @repo Attribrutex.RepoClient.repo

  @valid_attrs %{key: "field", field_type: :string, fieldable_type: "User"}
  @valid_context_attrs %{key: "field", field_type: :string,
    fieldable_type: "User", context_id: 123, context_type: "User"}
  @valid_context_attrs_2 %{key: "field", field_type: :string,
    fieldable_type: "User", context_id: 124, context_type: "User"}

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

  test "changeset with repeated field without context" do
    @repo.insert(CustomField.changeset(%CustomField{}, @valid_attrs))
    {status, _} = @repo.insert(CustomField.changeset(%CustomField{}, @valid_attrs))
    assert status == :error
  end

  test "changeset with context with repeated fields for same fieldable_type" do
    @repo.insert(CustomField.changeset(%CustomField{}, @valid_context_attrs))
    {status, _} = @repo.insert(CustomField.changeset(%CustomField{}, @valid_context_attrs_2))
    assert status == :ok
  end

  test "changeset with context with repeated fields for same context" do
    @repo.insert(CustomField.changeset(%CustomField{}, @valid_context_attrs))
    {status, _} = @repo.insert(CustomField.changeset(%CustomField{}, @valid_context_attrs))
    assert status == :error
  end
end
