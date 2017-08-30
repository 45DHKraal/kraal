{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:faker_elixir_octopus)


ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Kraal.Repo, :manual)
