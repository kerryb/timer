# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :timer, TimerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8LfDePdPW8zf2dzTL0J904IA2sgwBqCuM27e3zwTvAywKLAIn8/D4r8SiwqN1Lde",
  render_errors: [view: TimerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Timer.PubSub,
  live_view: [signing_salt: "FX3H+zH5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
