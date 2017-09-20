defmodule Kraal.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    StatusEnum.create_type
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :text
      add :published_at, :utc_datetime, default: fragment("now()")
      add :slug, :string
      add :status, :status

      add :author_id, references(:profiles, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create unique_index(:posts, [:slug])

  end
end
