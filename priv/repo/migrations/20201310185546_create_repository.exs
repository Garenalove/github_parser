defmodule GithubParser.Repo.Migrations.CreateRepository do
  use Ecto.Migration

  def change do
    create table(:repository, primary_key: false) do
      add :title, :string, primary_key: true
      add :description, :text
      add :stars, :int
      add :daily_stars, :int
      add :forks, :int
      add :language, :string
      add :language_color, :string
      add :avatar_url, :string
      add :url, :string
      timestamps()
    end

    create index(:repository, [:title], unique: true)
  end
end
