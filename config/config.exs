# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kraal, ecto_repos: [Kraal.Repo], generators: [binary_id: true]
# Configures the endpoint
config :kraal,
       KraalWeb.Endpoint,
       url: [host: "localhost"],
       secret_key_base: "Npz61zCv52mBeWbBksV6AUiv/jzspLyb+tcTEz20N9sAw5KdP8bVRQP+s/kcBNdH",
       secret_key_activation_token: "MwO5VMD4nt6KE8GU+ZJhfVtz1oDPnhxQ/ZYXJ381kAlOv5Cut3SxMHh6LmzoPnOi",
       render_errors: [view: KraalWeb.ErrorView, accepts: ~w(html json)],
       pubsub: [name: Kraal.PubSub, adapter: Phoenix.PubSub.PG2]
# Configures Elixir's Logger
config :logger,
       :console,
       format: "$time $metadata[$level] $message\n", metadata: :all

config :scrivener_html,
        route_helpers: KraalWeb.Router.Helpers,
        view_style: :bulma

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
