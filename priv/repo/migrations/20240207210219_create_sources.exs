defmodule KM.Repo.Migrations.CreateSources do
  use Ecto.Migration

  def change do
    create table(:sources) do
      add :title, :string
      add :date, :date
      add :organization, :string
      add :classification, :string
      add :type, :string
      add :areas_of_interest, :string
      add :region, :string
      add :keywords, :string
      add :page_count, :string
      add :scanned_by, :string
   

      timestamps(type: :utc_datetime)
    end
  end
end
