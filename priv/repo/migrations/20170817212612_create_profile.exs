defmodule Kraal.Repo.Migrations.CreateProfile do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :first_name, :string
      add :last_name, :string
      add :birth_date, :date

      add :user_id, references(:users, on_delete: :nothing, type: :uuid)
      timestamps()
    end

  end
end
