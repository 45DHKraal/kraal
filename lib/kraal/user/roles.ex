defmodule Kraal.User.Roles do
  use Ecto.Schema

  embedded_schema do
    field :admin, :boolean, default: false
    field :scoutmaster, :boolean, default: false
    field :blog_writer, :boolean, default: false
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, ~w(admin scoutmaster blog_writer))
  end
end
