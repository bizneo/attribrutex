defmodule AttribrutexTest do
  use ExUnit.Case

  doctest Attribrutex

  @repo Attribrutex.RepoClient.repo

  setup do
    @repo.delete_all(Attribrutex.CustomField)
    :ok
  end

  test "create_custom_field/4" do
    {status, resource} =
      Attribrutex.create_custom_field("sample", :string, AttribrutexUser)

    assert status == :ok
    assert resource.key == "sample"
    assert resource.field_type == :string
    assert resource.fieldable_type == "AttribrutexUser"
  end

  test "create_custom_field/4 with context" do
    {status, resource} =
      Attribrutex.create_custom_field("sample", :string, AttribrutexUser, context_id: 1, context_type: "User")

    assert status == :ok
    assert resource.key == "sample"
    assert resource.field_type == :string
    assert resource.fieldable_type == "AttribrutexUser"
    assert resource.context_id == 1
    assert resource.context_type == "User"
  end

  test "list_custom_fields_for/2" do
    Attribrutex.create_custom_field("stuff", :integer, User)

    result = Attribrutex.list_custom_fields_for(User)
    custom_field = Enum.at(result, 0)

    assert length(result) == 1
    assert custom_field.__struct__ == Attribrutex.CustomField
  end

  test "list_custom_fields_for/2 with context" do
    Attribrutex.create_custom_field("stuff", :integer, User)
    Attribrutex.create_custom_field("location", :integer, User, context_id: 1, context_type: "User")

    result = Attribrutex.list_custom_fields_for(User, %{context_id: 1, context_type: "User"})
    custom_field = Enum.at(result, 0)

    assert length(result) == 1
    assert custom_field.key == "location"
  end

  test "list_custom_fields_for/2 with :keys mode" do
    Attribrutex.create_custom_field("stuff", :integer, User)

    result = Attribrutex.list_custom_fields_for(User, %{mode: :keys})
    custom_field = Enum.at(result, 0)

    assert length(result) == 1
    assert custom_field == "stuff"
  end

  test "list_custom_fields_for/2 with :fields mode" do
    Attribrutex.create_custom_field("stuff", :integer, User)

    result = Attribrutex.list_custom_fields_for(User, %{mode: :fields})
    custom_field = Enum.at(result, 0)

    assert length(result)    == 1
    assert custom_field.key  == "stuff"
    assert custom_field.type == :integer
  end
end
