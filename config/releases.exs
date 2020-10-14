import Config

config :github_parser, GithubParser.Repo,
  username: System.fetch_env!("DB_USER"),
  password: System.fetch_env!("DB_PASS"),
  database: System.fetch_env!("DB_NAME"),
  hostname: System.fetch_env!("DB_HOST")

case System.get_env("GITHUB_TOKEN") do
  token when is_binary(token) ->
    config :github_parser, :trends,
      headers: [{"Authorization", "token " <> token}]

  _ ->
    config :github_parser, :trends,
      headers: []
end
