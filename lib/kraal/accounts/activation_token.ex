defmodule Kraal.Accounts.ActivationToken do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts_activation_tokens" do
    belongs_to :user, Kraal.Accounts.User 

    timestamps()
  end
end
