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

config :github_parser, :trends,
  url: "localhost",
  options: [timeout: 50_000, recv_timeout: 50_000],
  update_interval:  60 * 60 * 1000

config :logger, level: :warn
