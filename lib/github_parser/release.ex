defmodule GithubParser.Release do
  @app :github_parser
  require Logger

  def create_db do
    for repo <- repos() do
      case repo.__adapter__.storage_up(repo.config) do
        :ok -> Logger.info("Database created")
        {:error, msg} -> Logger.info(to_string(msg))
      end
    end
  end

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
