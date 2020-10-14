defmodule GithubParserWeb.FallbackController do
  use GithubParserWeb, :controller
  require Logger

  def call(conn, {:error, :not_found}) do
    conn
    |> send_resp(404, "not found")
  end

  def call(conn, error) do
    Logger.error("Unknown API error. error: #{inspect(error)}")
    conn
    |> send_resp(500, "internal server error")
  end
end
