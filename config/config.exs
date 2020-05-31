# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :slack_noodling,
  ecto_repos: [SlackNoodling.Repo]

config :slack_noodling, SlackNoodling.Application,
  pubsub: [
    phoenix_pubsub: [
      adapter: Phoenix.PubSub.PG2,
      pool_size: 1
    ]
  ]

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :slack_noodling, event_stores: [SlackNoodling.EventStore]

# Configures the endpoint
config :slack_noodling, SlackNoodlingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Yds9P7AFT3BBLfPhFieoVvQGUMYCgbK4tIXeIQpeTXQQZgYH9nORt43gWjV6cMH1",
  render_errors: [view: SlackNoodlingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SlackNoodling.PubSub,
  live_view: [signing_salt: "kFc5Pmmm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
