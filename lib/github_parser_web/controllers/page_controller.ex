defmodule GithubParserWeb.PageController do
  use GithubParserWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
