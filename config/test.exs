import Config

config :github_parser, GithubParser.Repo,
  username: "postgres",
  password: "postgres",
  database: "github_parser",
  hostname: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :github_parser, GithubParserWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
