defmodule GithubParser.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      GithubParser.Repo,
      GithubParserWeb.Telemetry,
      {Phoenix.PubSub, name: GithubParser.PubSub},
      GithubParserWeb.Endpoint,
    ] ++ repos_worker()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GithubParser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GithubParserWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def repos_worker() do
    if unquote(Mix.env != :test) do
      [{GithubParser.Workers.Repos, []}]
    else
      []
    end
  end
end
