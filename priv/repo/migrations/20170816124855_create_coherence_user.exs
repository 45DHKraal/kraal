defmodule Kraal.Repo.Migrations.CreateCoherenceUser do
  use Ecto.Migration
  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :email, :string
      # authenticatable
      add :password_hash, :string
      add :active, :boolean, null: false, default: true
      # recoverable
      add :reset_password_token, :string
      add :reset_password_sent_at, :utc_datetime
      # unlockable_with_token
      add :unlock_token, :string

      timestamps()
    end
    create unique_index(:users, [:email])

  end
end
