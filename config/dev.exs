import Config

config :github_parser, GithubParser.Repo,
  username: "postgres",
  password: "postgres",
  database: "github_parser_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :github_parser, GithubParserWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :github_parser, :trends,
  url: "https://hackertab.pupubird.com/repositories",
  options: [timeout: 50_000, recv_timeout: 50_000],
  update_interval: 3 * 10 * 1000

config :github_parser, GithubParserWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/github_parser_web/(live|views)/.*(ex)$",
      ~r"lib/github_parser_web/templates/.*(eex)$"
    ]
  ]

config :logger, :info, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
