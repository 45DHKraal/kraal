defmodule Kraal.User do
  use Ecto.Schema
  alias Kraal.User.Roles

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :activated, :boolean
    embeds_one :roles, Roles do
      field :admin, :boolean, default: false
      field :scoutmaster, :boolean, default: false
      field :blog_writer, :boolean, default: false
    end

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, ~w(email password_hash activated))
    |> Ecto.Changeset.cast_embed(:roles)
    |> Ecto.Changeset.put_embed(:roles, Roles.changeset(%Roles{}, params[:roles] || %{}))
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, ~w(email))
  end

end
