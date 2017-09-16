{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:faker_elixir_octopus)

if System.get_env("CI") do
  ExUnit.configure formatters: [JUnitFormatter]
end
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Kraal.Repo, :manual)
