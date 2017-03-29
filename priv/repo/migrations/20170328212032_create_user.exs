defmodule Kraal.Repo.Migrations.CreateKraal.User do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :password_hash, :string
      add :activated, :boolean, default: false
      add :roles, :map

      timestamps()
    end

  end
end
