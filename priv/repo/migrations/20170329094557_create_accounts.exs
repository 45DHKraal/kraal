defmodule Kraal.Repo.Migrations.CreateKraal.Accounts do
  use Ecto.Migration

  def change do
    create table(:accounts_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :password_hash, :string
      add :activated, :boolean, default: false
      add :roles, :map

      timestamps()
    end

    create unique_index(:accounts_users, [:email])

    create table(:accounts_activation_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:accounts_users, type: :binary_id)

      timestamps()
    end
  end
end
