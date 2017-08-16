defmodule Kraal.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kraal.Accounts.Profile


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profile" do

    timestamps()
  end

  @doc false
  def changeset(%Profile{} = profile, attrs) do
    profile
    |> cast(attrs, [])
    |> validate_required([])
  end
end
