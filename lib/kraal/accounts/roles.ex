defmodule Kraal.Accounts.Roles do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kraal.Accounts.Roles


  embedded_schema do
    field :admin, :boolean, default: false
    field :scoutmaster, :boolean, default: false
    field :blog_writer, :boolean, default: false
  end

  @doc false
  def changeset(%Roles{} = role, attrs) do
    role
    |> cast(attrs, ~w(admin scoutmaster blog_writer))
    
  end
end
