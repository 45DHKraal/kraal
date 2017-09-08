defmodule Kraal.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :text
      add :published, :boolean, default: false, null: false
      add :published_at, :utc_datetime
      add :slug, :string

      add :parent_id, references(:pages, on_delete: :nothing, type: :uuid)

      timestamps()
    end

  end
end
