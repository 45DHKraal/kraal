defmodule Kraal.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Kraal.Accounts.User

  @primary_key {:id, :binary_id, [autogenerate: true]}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :current_password, :string, virtual: true
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :active, :boolean, default: false
    field :reset_password_token, :string
    field :reset_password_sent_at, Ecto.DateTime
    field :confirmation_token, :string
    field :confirmed_at, Ecto.DateTime
    field :confirmation_sent_at, Ecto.DateTime
    has_one :profile, Kraal.Accounts.Profile
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :active])
    |> validate_required([:email, :password])
  end

  def register_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password, required: true)
    |> unique_constraint(:email)
    |> generate_confirmation_token()
    |> generate_password_hash()
  end

  def generate_password_hash(changeset) do
    password = get_change(changeset, :password)
    changeset
    |> put_change(:password_hash, Comeonin.Argon2.hashpwsalt(password))
  end

  def generate_confirmation_token(changeset) do
    email = get_change(changeset, :email)
    changeset
    |> put_change(:confirmation_token, Comeonin.Argon2.hashpwsalt(email))
  end

end
