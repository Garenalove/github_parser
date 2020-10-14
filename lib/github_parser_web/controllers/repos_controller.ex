defmodule GithubParserWeb.ReposController do
  use GithubParserWeb, :controller

  action_fallback GithubParserWeb.FallbackController

  alias GithubParser.Repositories
  alias GithubParser.Workers.Repos

  def get_all(conn, _params) do
    json(conn, Repositories.get_all())
  end

  def get_by(conn, %{"query" => query}) when not is_nil(query) do
    case Integer.parse(query) do
      {id, ""} when is_integer(id) ->
        get_by_id(id, conn)

      _ ->
        get_by_title(query, conn)
    end
  end

  def force_update(conn, _params) do
    with :ok <- Repos.force_update() do
      json(conn, %{"status" => "ok"})
    end
  end

  defp get_by_id(id, conn) do
    with {:ok, repo} <- Repositories.get_by_id(id) do
      json(conn, repo)
    end
  end

  defp get_by_title(title, conn) do
    with {:ok, repo} <- Repositories.get_by_title(title) do
      json(conn, repo)
    end
  end
end
