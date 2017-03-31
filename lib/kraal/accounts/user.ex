defmodule Kraal.Accounts.User do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts_users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :activated, :boolean
    embeds_one :roles, Kraal.Accounts.Roles

    timestamps()
  end
end
