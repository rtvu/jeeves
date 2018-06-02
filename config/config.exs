# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :jeeves,
  ecto_repos: [Jeeves.Repo]

# Configures the endpoint
config :jeeves, JeevesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DcMjvUQQoD/WyrIdqU3Dzy4HCF0L7MIz/8Gx8qxptzyRvNAMgzB7ITPy2Hg4d+NO",
  render_errors: [view: JeevesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Jeeves.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
