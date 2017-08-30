# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kraal.Repo.insert!(%Kraal.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Kraal.Coherence.User

User.changeset(%User{}, %{email: "test@kraal.pl", password: "test"})
  |> Kraal.Repo.insert!
  |> Ecto.build_assoc( :profile, first_name: "Test", last_name: "Testowo", birth_date: ~D[1989-11-15] )
  |> Kraal.Repo.insert!
