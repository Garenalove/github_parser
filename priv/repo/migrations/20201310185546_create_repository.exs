defmodule GithubParser.Repo.Migrations.CreateRepository do
  use Ecto.Migration

  def change do
    create table(:repository) do
      add :title, :string
      add :description, :text
      add :stars, :int
      add :forks, :int
      add :language, :string
      add :avatar_url, :string
      add :url, :string
      timestamps()
    end

    create index(:repository, [:id], unique: true)
  end
end
