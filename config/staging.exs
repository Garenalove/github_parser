import Config

config :github_parser, :trends,
  url: "https://hackertab.pupubird.com/repositories",
  options: [timeout: 50_000, recv_timeout: 50_000],
  update_interval:  60 * 60 * 1000


config :github_parser, GithubParser.Repo,
  pool_size: 10

config :github_parser, GithubParserWeb.Endpoint,
  http: [port: 4000],
  server: true
