import Config

config :github_parser, GithubParser.Repo,
  username: System.fetch_env!("DB_USER"),
  password: System.fetch_env!("DB_PASS"),
  database: System.fetch_env!("DB_NAME"),
  hostname: System.fetch_env!("DB_HOST")
