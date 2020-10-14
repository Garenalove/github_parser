defmodule GithubParser.DbTest do
  use GithubParser.DataCase

  alias GithubParser.Repositories

  @valid_repo %{
    id: 1,
    title: "test",
    description: "test",
    stars: 1337,
    forks: 1337,
    language: "elixir",
    avatar_url: "test",
    url: "test"
  }

  describe "create or update" do
    test "crate valid repo" do
      assert {:ok, _} = Repositories.update({[@valid_repo], [1]})
      assert {:ok, @valid_repo} == Repositories.get_by_id(1)
    end

    test "update existing repo" do
      Repositories.update({[@valid_repo], [1]})
      updated_repo = Map.put(@valid_repo, :title, "test1")
      assert {:ok, _} = Repositories.update({[updated_repo], [1]})
      assert {:ok, updated_repo} == Repositories.get_by_id(1)
    end

    test "try creatae invalid repo" do
      assert {:error, _, :wrong_repos, _} = Repositories.update({[Map.delete(@valid_repo, :id)], [1]})
      assert {:error, :not_found} == Repositories.get_by_id(1)
    end

    test "try update repo with invalid title" do
      Repositories.update({[@valid_repo], [1]})
      invalid_repo = Map.put(@valid_repo, :title, 1337)
      assert {:error, _, :wrong_repos, _} = Repositories.update({[invalid_repo], [1]})
      assert {:ok, @valid_repo} == Repositories.get_by_id(1)
    end
  end

  describe "get repos" do
    setup do
      Repositories.update({[@valid_repo], [1]})
      :ok
    end

    test "get all repos" do
      assert [@valid_repo] == Repositories.get_all()
    end

    test "get by id" do
      assert {:ok, @valid_repo} == Repositories.get_by_id(1)
    end

    test "get by title" do
      assert {:ok, @valid_repo} == Repositories.get_by_title(Map.get(@valid_repo, :title))
    end

    test "try get undefined repo by id" do
      assert {:error, :not_found} == Repositories.get_by_id(1337)
    end

    test "try get undefined repo by title" do
      assert {:error, :not_found} == Repositories.get_by_title("title")
    end
  end
end
