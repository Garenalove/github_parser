import Config

config :github_parser, GithubParser.Repo,
  pool_size: 10

config :github_parser, GithubParserWeb.Endpoint,
  http: [port: 4000],
  server: true
