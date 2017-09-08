defmodule Kraal.Cms.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kraal.Cms.Page


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pages" do
    field :content, :string
    field :published, :boolean, default: false
    field :published_at, :utc_datetime
    field :slug, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Page{} = page, attrs) do
    page
    |> cast(attrs, [:title, :content, :published, :published_at, :slug])
    |> validate_required([:title, :content, :published, :published_at, :slug])
  end
end
