{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:faker_elixir_octopus)

if System.get_env("CI") == true do
  ExUnit.configure formatters: [JUnitFormatter, ExUnit.CLIFormatter]
end
ExUnit.start(exclude: [:skip])

Ecto.Adapters.SQL.Sandbox.mode(Kraal.Repo, :manual)
