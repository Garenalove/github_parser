defmodule GithubParser.Schemas.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :title,
    :description,
    :stars,
    :forks,
    :language,
    :avatar_url,
    :url
  ]

  @required_fields @fields -- [:description, :language]

  @schema_meta_fields [:__meta__, :inserted_at, :updated_at]

  @primary_key {:id, :id, autogenerate: false}

  schema "repository" do
    field :title, :string
    field :description, :string
    field :stars, :integer
    field :forks, :integer
    field :language, :string
    field :avatar_url, :string
    field :url, :string

    timestamps()
  end

  def changeset(repository, attrs) do
    repository
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:title)
  end

  def to_storeable_map(nil), do: nil

  def to_storeable_map(struct) do
    association_fields = struct.__struct__.__schema__(:associations)
    waste_fields = association_fields ++ @schema_meta_fields

    struct
    |> Map.from_struct()
    |> Map.drop(waste_fields)
  end
end
