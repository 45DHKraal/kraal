# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kraal,
  ecto_repos: [Kraal.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :kraal, KraalWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Npz61zCv52mBeWbBksV6AUiv/jzspLyb+tcTEz20N9sAw5KdP8bVRQP+s/kcBNdH",
  render_errors: [view: KraalWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kraal.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Kraal.Coherence.User,
  repo: Kraal.Repo,
  module: Kraal,
  web_module: KraalWeb,
  router: KraalWeb.Router,
  messages_backend: KraalWeb.Coherence.Messages,
  logged_out_url: "/",
  user_active_field: true,
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :unlockable_with_token, :invitable]

config :coherence, KraalWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Kraal.Coherence.User,
  repo: Kraal.Repo,
  module: Kraal,
  web_module: KraalWeb,
  router: KraalWeb.Router,
  messages_backend: KraalWeb.Coherence.Messages,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :unlockable_with_token, :confirmable]

config :coherence, KraalWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%
