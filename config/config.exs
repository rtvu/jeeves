# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :jeeves,
  ecto_repos: [Jeeves.Repo]

# Configures the endpoint
config :jeeves, JeevesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LWMsthDEbq6C8NZYMzZuMOhzj8S5vEITyzToI/zDzEjW2V8Xk9XwM3erub/ytndM",
  render_errors: [view: JeevesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Jeeves.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
