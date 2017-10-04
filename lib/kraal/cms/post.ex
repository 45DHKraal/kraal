defmodule Kraal.Cms.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kraal.Cms.Post


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :content, :string
    field :published_at, :utc_datetime
    field :slug, :string
    field :title, :string
    field :status, Kraal.Cms.StatusEnum

    belongs_to :author, Kraal.Accounts.Profile

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published_at, :status, :author_id])
    |> assoc_constraint(:author)
    |> validate_required([:title, :content, :published_at,  :status])
    |> create_slug
    |> unique_constraint(:slug)
  end

  def create_slug(changeset) do
    Slugify.slugify(changeset)
  end
end
