defmodule Kraal.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :password_hash, :string
      add :roles, :map
      add :reset_password_token, :string
      add :reset_password_sent_at, :utc_datetime
      add :confirmation_token, :string
      add :confirmed_at, :utc_datetime
      add :confirmation_sent_at, :utc_datetime
      add :deleted_at, :utc_datetime
      timestamps()
    end
    create unique_index(:users, [:email])
  end
end
