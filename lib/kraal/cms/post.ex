defmodule Kraal.Cms.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kraal.Cms.Post


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :content, :string
    field :published, :boolean, default: false
    field :published_at, :utc_datetime
    field :slug, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published, :published_at, :slug])
    |> validate_required([:title, :content, :published, :published_at, :slug])
  end
end
