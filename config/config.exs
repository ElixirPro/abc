# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :offer_consumer,
  ecto_repos: [OfferConsumer.Repo]

# Configures the endpoint
config :offer_consumer, OfferConsumerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5+anW6n6tASPgpZ37/ea5u7G/AkDXv9j8SYOV2R9F60lEa1Zeur/EbzunJNiI4SX",
  render_errors: [view: OfferConsumerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: OfferConsumer.PubSub,
  live_view: [signing_salt: "KDAkxemn"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
