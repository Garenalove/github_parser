defmodule GithubParser.Repositories do
  import Ecto.Query

  alias Ecto.Multi
  alias GithubParser.Schemas.Repository
  alias GithubParser.Repo

  def update({repos, ids}) do
    Multi.new()
    |> Multi.delete_all(:delete_old, from(r in Repository, where: r.id not in ^ids))
    |> Multi.run(:get_exist, fn repo, _changes ->
      repositories = Enum.map(repos, &get_or_create(repo, &1))
      if Enum.all?(repositories, fn repo -> repo != :error end) do
        {:ok, repositories}
      else
        {:error, :wrong_repos}
      end
    end)
    |> Multi.run(:insert_or_update, fn repo, %{get_exist: repositores} ->
      repositores
      |> Enum.map(&repo.insert_or_update(&1))
      |> Enum.all?(fn {term, _} -> term == :ok end)
      |> if do
        {:ok, :success}
      else
        {:error, :wrong_repos}
      end
    end)
    |> Repo.transaction()
  end

  def get_by_id(id) do
    Repo.get(Repository, id)
    |> get_by()
  end

  def get_by_title(title) do
    Repo.get_by(Repository, title: title)
    |> get_by()
  end

  defp get_by(query) do
    query
    |> Repository.to_storeable_map()
    |> case do
      nil -> {:error, :not_found}

      repo -> {:ok, repo}
    end
  end

  def get_all() do
    from(
      r in Repository,
      order_by: [desc: r.stars]
    )
    |> Repo.all()
    |> Enum.map(&Repository.to_storeable_map(&1))
  end

  defp get_or_create(repo, %{id: id} = repository) when is_integer(id) do
    (repo.get(Repository, Map.get(repository, :id)) || %Repository{})
    |> Repository.changeset(repository)
  end

  defp get_or_create(_, _), do: :error
end
