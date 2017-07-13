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
end
