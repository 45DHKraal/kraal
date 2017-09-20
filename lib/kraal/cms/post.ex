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
    field :status, StatusEnum

    belongs_to :author, Kraal.Accounts.Profile

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published_at, :status, :author_id])
    |> create_slug
    |> assoc_constraint(:author)
    |> validate_required([:title, :content, :published_at,  :slug, :status])
    |> unique_constraint(:slug)
  end

  defp create_slug(changeset) do
    title = get_change(changeset, :title)
      |> Slugger.slugify_downcase
    %DateTime{:year=> year, :month=> month} = get_change(changeset, :published_at)


    put_change(changeset, :slug, "/#{year}/#{month}/#{title}")
  end
end
