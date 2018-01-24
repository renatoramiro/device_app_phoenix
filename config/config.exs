# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :devices_app,
  ecto_repos: [DevicesApp.Repo]

# Configures the endpoint
config :devices_app, DevicesAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "m+KnoQDCUUsBsadV8XXhYFtgh/PHzW8TEEKV1Uha/pQvbvIMc5KuHZD03IZ9NcZs",
  render_errors: [view: DevicesAppWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DevicesApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :devices_app, DevicesApp.Auth.Guardian,
        issuer: "devices_app",
        secret_key: "uQReaN/LeuDmXrS2+gaEkjfcDoVFHpizHu/IQnyIFZKrNE4RY1jYfAkbkg+I+V5y",
        error_handler: DevicesApp.Auth.ErrorHandler

config :cors_plug,
        origin: ["*"],
        max_age: 86400,
        methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
