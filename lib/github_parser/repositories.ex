defmodule GithubParser.Repositories do
  import Ecto.Query

  alias Ecto.Multi
  alias GithubParser.Schemas.Repository
  alias GithubParser.Repo

  def update({repos, titles}) do
    Multi.new()
    |> Multi.delete_all(:delete_old, from(r in Repository, where: r.title not in ^titles))
    |> generate_insert(repos)
    |> Repo.transaction()
  end

  def get_by_title(title) do
    Repo.get_by(Repository, title: title)
    |> Repository.to_storeable_map()
    |> case do
      nil -> {:error, :not_found}

      repo -> {:ok, repo}
    end
  end

  def get_all() do
    from(
      r in Repository,
      order_by: [desc: r.daily_stars]
    )
    |> Repo.all()
    |> Enum.map(&Repository.to_storeable_map(&1))
  end

  defp generate_insert(transaction, repos) do
    repos
    |> Enum.reduce(transaction, fn repo, transaction ->
      Multi.insert(transaction, Map.get(repo, :title), Repository.changeset(%Repository{}, repo), on_conflict: :nothing)
    end)
  end
end
