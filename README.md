[![CircleCI](https://circleci.com/gh/bizneo/Attribrutex/tree/master.svg?style=svg)](https://circleci.com/gh/bizneo/Attribrutex/tree/master)

# Attribrutex
Configure custom fields dynamically on your Phoenix models

## Installation

  1. Add `attribrutex` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:attribrutex, "~> 0.1.0"}]
  end
  ```

  2. Configure Attribrutex to use your repo in `config/config.exs`:

  ```elixir
  config :attribrutex, repo: ApplicationName.Repo
  ```

  3. Install your dependencies:

  ```elixir
  mix deps.get
  ```

  4. Generate the migrations:

  ```elixir
  mix attribrutex.install
  ```

  5. Run the migrations:

  ```elixir
  mix ecto.migrate
  ```

  6. Generate necessary migration for each table where you want to allow
     dinamyc fields and run it:

  ```elixir
  mix attribrutex.migrate <table_name>
  mix ecto.migrate
  ```
  7. Add the field to the schema in your models (is important to set a
     default value):

  ```elixir
  field :custom_fields, :map, default: %{}
  ```

## Usage

Attribrutex works with three basic functions:


### Creating a new field

Using `create_custom_field(key, type, module, opts \\ []` you can
create a new field for a specific module

i.e.:

  ```elixir
  Attribrutex.create_custom_field("location", :string, User)
  ```

As you can see you can specify a set of supported **data types**:

- `:string`
- `:integer`
- `:boolean`
- `:float`

If you need to create a field on specific context, for example,
you need every user to have their own fields, not accessible for
any other user, then, you can use the opts
to make the new field belongs to a specific resource:

  ```elixir
  Attribrutex.create_custom_field("location", :string, Job,
                                   context_id: 1, context_type: "User")
  ```

After that, you will have a "location" string field on the `Job` model
and only accessible by the user with the id 1

### Listing fields

Use `list_custom_fields_for(module, opts \\ %{})` to list the fields for
a module. If you want to get the fields for a context you can use opts
field and set a `:context_id` and `:context_type` keys.

It also supports a `:mode` param to return the fields in different ways:

 * `:keys` - Only returns the key values for every entry.
 * `:fields` - Returns a list of maps with `:key` and `type` keys

If `:mode` key doesn't exist, all the struct will be returned.

### Adding new values to the custom fields

You can use `prepare_custom_fields(changeset, params, opts \\ %{})` to
add the changes to your changeset.

We recommend adding the function to your changeset function to deal with
custom_fields:

  ```elixir
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

In case that a param value doesn't match with the type, an error will be
set on the changeset:

  ```elixir
 #Ecto.Changeset<action: nil, changes: %{email: "example@example.com"},
 errors: [custom_fields: {"Bad data type", [custom_field: :location]}],
 data: #AttribrutexUser<>, valid?: false>
 ```

## Usage example

Here we expose a full workflow example where we create a field, list it
and add some value.

  ```elixir
  Attribrutex.create_custom_field("sample", :string, AttribrutexUser)
  # {:ok,
  #   %Attribrutex.CustomField{__meta__: #Ecto.Schema.Metadata<:loaded, "custom_fields">,
  #     context_id: nil, context_type: nil, field_type: :string,
  #     fieldable_type: "AttribrutexUser", id: 1231,
  #     inserted_at: ~N[2017-07-20 13:08:35.134738], key: "sample",
  #     updated_at: ~N[2017-07-20 13:08:35.134761]}}

  Attribrutex.list_custom_fields_for(AttribrutexUser)
  # [%Attribrutex.CustomField{__meta__: #Ecto.Schema.Metadata<:loaded, "custom_fields">,
  #   context_id: nil, context_type: nil, field_type: :string,
  #   fieldable_type: "AttribrutexUser", id: 1248,
  #   inserted_at: ~N[2017-07-20 13:14:25.997483], key: "sample",
  #   updated_at: ~N[2017-07-20 13:14:25.997505]}]

  Attribrutex.list_custom_fields_for(AttribrutexUser, %{mode: :fields})
  # [%{key: "sample", type: :string}]

  Attribrutex.list_custom_fields_for(AttribrutexUser, %{mode: :keys})
  # ["sample"]

  AttribrutexUser.changeset(%AttribrutexUser{}, %{email: "example@example.com", location: "Paris"})
  # Ecto.Changeset<action: nil,
  #  changes: %{custom_fields: %{location: "Madrid"}, email: "asdf@asdf.com"},
  #  errors: [], data: #AttribrutexUser<>, valid?: true>
  ```

## Testing

Clone the repo and fetch dependencies with `mix deps.get`

Executing `mix test` should run all the tests.

## License

See [LICENSE](https://github.com/bizneo/attribrutex/blob/master/LICENSE.md)
