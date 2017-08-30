defmodule Kraal.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kraal.Accounts.Profile


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profile" do

    field :first_name, :string
    field :last_name, :string
    field :birth_date, :date

    belongs_to :user, Kraal.Coherence.User
    timestamps()
  end

  @doc false
  def changeset(%Profile{} = profile, attrs) do
    profile
    |> cast(attrs, [:first_name, :last_name, :birth_date])
    |> validate_required([:first_name, :last_name, :birth_date])
  end
end
