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
    field :reset_password_token, :string
    field :reset_password_sent_at, Ecto.DateTime
    field :confirmation_token, :string
    field :confirmed_at, Ecto.DateTime
    field :confirmation_sent_at, Ecto.DateTime
    field :deleted_at, Ecto.DateTime
    has_one :profile, Kraal.Accounts.Profile
    embeds_one :roles, Roles do
      field :admin, :boolean, default: false
      field :cms_admin, :boolean, default: false
      field :active_scout, :boolean, default: false
    end
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :deleted_at, :confirmation_sent_at, :confirmed_at, :confirmation_token, :reset_password_sent_at])
    |> validate_required([:email])
  end

  def register_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> cast_embed(:roles, with: &roles_changeset/2)
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, required: true)
    |> unique_constraint(:email)
    |> generate_confirmation_token()
    |> generate_password_hash()
  end

  def generate_password_hash(changeset) do
    case changeset.valid? do
      true -> password = get_change(changeset, :password)
              changeset
              |> put_change(:password_hash, Comeonin.Argon2.hashpwsalt(password))
      _ -> changeset
    end
  end

  def generate_confirmation_token(changeset) do
    case changeset.valid? do
      true -> email = get_change(changeset, :email)
              changeset
              |> put_change(:confirmation_token, Comeonin.Argon2.hashpwsalt(email))
        _ -> changeset
    end

  end

  def check_password(%User{} = user, password) do
    Comeonin.Argon2.check_pass(user, password)
  end

  def is_confirmed(%User{} = user) do
    case is_nil(user.confirmed_at) do
      true -> {:error, "not confirmed"}
      _ -> {:ok, user}
    end
  end

  defp roles_changeset(schema, params) do
    schema
    |> cast(params, [:admin, :cms_admin, :active_scout])
  end

end
