defmodule GithubParser.Repo do
  use Ecto.Repo,
    otp_app: :github_parser,
    adapter: Ecto.Adapters.Postgres
end
