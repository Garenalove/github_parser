defmodule GithubParserWeb.ReposController do
  use GithubParserWeb, :controller

  action_fallback GithubParserWeb.FallbackController

  alias GithubParser.Repositories
  alias GithubParser.Workers.Repos

  def get_all(conn, _params) do
    json(conn, Repositories.get_all())
  end

  def get_by_title(conn, %{"title" => title}) do
    with {:ok, repo} <- Repositories.get_by_title(title) do
      json(conn, repo)
    end
  end

  def force_update(conn, _params) do
    with :ok <- Repos.force_update() do
      json(conn, %{"status" => "ok"})
    end
  end
end
