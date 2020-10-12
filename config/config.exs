import Config

config :github_parser,
  ecto_repos: [GithubParser.Repo]

config :github_parser, GithubParserWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "f3s3pQfAEkzu+HRV3wWzELFf9RjVsTHbL6ykCm3gqtFMvavkLHlwXWq7H4C/Q/gs",
  render_errors: [view: GithubParserWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GithubParser.PubSub,
  live_view: [signing_salt: "DudbhR42"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
