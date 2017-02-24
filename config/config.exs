# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :alisinabh, Alisinabh.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "I8teyehw9XFtZpLXNdoKWMlk0HDP8rfGFB4t8lrDMz75iDG4kOekJ5JHxs7B5C05",
  render_errors: [view: Alisinabh.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Alisinabh.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :alisinabh, repo_path: "blogrepo/"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
