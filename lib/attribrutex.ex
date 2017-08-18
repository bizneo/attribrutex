defmodule Attribrutex do
  @moduledoc """
  Public functions to manage custom fields
  """
  import Ecto.Query
  import Attribrutex.RepoClient

  alias Attribrutex.CustomField
  alias Attribrutex.Changeset

  @type ok :: {:ok, CustomField.t}
  @type error :: {:error, {:ecto, Ecto.Changeset.t}}

  @doc """
  Creates a new field for a module.

  If you need specify a context, in example, the custom field belongs
  to a specific user, you can use the opts to set a `context_id` and a
  `context_type`.

  ## Example

     Attribrutex.create_custom_field("location", :string, User)

  Now, the custom field belongs to the `User` model

  ## Context example

     Attribrutex.create_custom_field("location", :string, User, context_id: user.id, context_type: "User")

  Setting a context, you can make fields available only for an specific resource

  """

  @spec create_custom_field(String.t, atom, list) :: ok | error
  def create_custom_field(key, type, module, opts \\ [])
  def create_custom_field(key, type, module, [context_id: context_id, context_type: context_type] = opts) do
    attrs = %{
      key: key,
      field_type: type,
      fieldable_type: module_name(module),
      context_id: context_id,
      context_type: context_type
    }

    insert_custom_field(attrs, opts)
  end
  def create_custom_field(key, type, module, opts) do
    attrs = %{
      key: key,
      field_type: type,
      fieldable_type: module_name(module)
    }

    insert_custom_field(attrs, opts)
  end

  defp insert_custom_field(attrs, opts) do
    with changeset <- CustomField.changeset(%CustomField{}, attrs) do
      repo().insert(changeset, opts)
    end
  end

  @doc """
  List fields for a module, you can pass a map with a `context_id` and
  `context_type` to search by context.

  It allow to return the fields in different formats adding `mode` param 
  in the options. `nil` value will return the structs.

  ## Mode params:

  * `:keys` - Only return the key values for every entry.
  * `:fields` - Return a list of maps with `key` and `type` keys.

  """
  @spec list_custom_fields_for(module, map) :: list
  def list_custom_fields_for(module, opts \\ %{}) do
    module
    |> module_name
    |> custom_field_query(opts[:context_id], opts[:context_type])
    |> select_custom_fields(opts[:mode])
    |> repo().all(prefix: opts[:prefix])
  end

  defp custom_field_query(fieldable_type, nil, nil), do: from c in CustomField, where: c.fieldable_type == ^fieldable_type
  defp custom_field_query(fieldable_type, context_id, context_type) do
    from c in CustomField,
      where: c.fieldable_type == ^fieldable_type and
        c.context_id == ^context_id and
        c.context_type == ^context_type
  end

  defp select_custom_fields(query, nil), do: query
  defp select_custom_fields(query, :keys), do: from c in query, select: c.key
  defp select_custom_fields(query, :fields), do: from c in query, select: %{key: c.key, type: c.field_type}

  @doc """
  Use it to manage custom_fields on building the changesets.
  You can use the opts like on `list_custom_fields_for/2` to set the
  `context_id` and `context_type`

  ## Example:

    ```
    defmodule AttribrutexUser do
      use Ecto.Schema
      import Ecto.Changeset

      schema "users" do
        field :email, :string
        field :custom_fields, :map, default: %{}

        timestamps()
      end

      def changeset(struct, params \\ %{}, opts \\ %{}) do
        struct
        |> cast(params, [:email])
        |> validate_required([:email])
        |> Attribrutex.prepare_custom_fields(params, opts)
      end
    end
    ```

  In case of detect a bad type for a field, an error will be added to
  changeset.errors

  ## Example

    ```
    #Ecto.Changeset<action: nil, changes: %{email: "example@example.com"},
    errors: [custom_fields: {"Bad data type", [custom_field: :location]}],
    data: #AttribrutexUser<>, valid?: false>
    ```

  """
  @spec prepare_custom_fields(Ecto.Changeset.t, map, map) :: Ecto.Changeset.t
  def prepare_custom_fields(changeset, params, opts \\ %{}) do
    with opts           <- Map.put(opts, :mode, :fields),
         custom_fields  <- list_custom_fields_for(changeset.data.__struct__, opts),
         custom_params  <- get_custom_params(custom_fields, params)
    do
      Enum.reduce(custom_params, changeset, fn(custom_param, changeset) ->
        Changeset.put(changeset, custom_param)
      end)
    end
  end

  defp get_custom_params(custom_fields, params) do
    Enum.reduce(custom_fields, [], fn(%{key: key, type: type}, custom_params) ->
      if value = params[field_name(key)] do
        with new_entry <- %{key: key_atom(key), value: value, type: type} do
          List.insert_at(custom_params, -1, new_entry)
        end
      end
    end)
  end

  defp field_name(field) when is_atom(field), do: Atom.to_string(field)
  defp field_name(field) when is_bitstring(field), do: field

  defp key_atom(key) when is_atom(key), do: key
  defp key_atom(key) when is_bitstring(key), do: String.to_atom(key)

  defp module_name(module), do: module |> Module.split |> List.last
end
