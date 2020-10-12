import Config

config :github_parser, GithubParser.Repo,
  username: "postgres",
  password: "postgres",
  database: "github_parser",
  hostname: "postgres",
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

config :github_parser, GithubParserWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/github_parser_web/(live|views)/.*(ex)$",
      ~r"lib/github_parser_web/templates/.*(eex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
