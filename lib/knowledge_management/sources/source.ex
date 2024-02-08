defmodule KM.Sources.Source do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sources" do
    field :type, :string
    field :date, :date
    field :title, :string
    field :keywords, :string
    field :organization, :string
    field :classification, :string
    field :areas_of_interest, :string
    field :region, :string
    field :page_count, :string
    field :scanned_by, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(source, attrs) do
    source
    |> cast(attrs, [:title, :date, :organization, :classification, :type, :areas_of_interest, :region, :keywords, :page_count, :scanned_by])
    |> validate_required([:title, :date, :organization, :classification, :type, :areas_of_interest, :region, :keywords, :page_count, :scanned_by])
  end
end
