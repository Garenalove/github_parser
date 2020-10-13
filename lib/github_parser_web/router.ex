defmodule GithubParserWeb.Router do
  use GithubParserWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GithubParserWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", GithubParserWeb do
    pipe_through :api

    get "/getRepos", ReposController, :get_all
    get "/getRepoByTitle", ReposController, :get_by_title
    post "/updateRepos", ReposController, :force_update
  end

end
