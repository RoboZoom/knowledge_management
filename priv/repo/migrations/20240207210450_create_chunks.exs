defmodule KM.Repo.Migrations.CreateChunks do
  use Ecto.Migration

  def change do
    create table(:chunks) do
      add :document_id, :uuid
      add :embedding, :vector

      timestamps(type: :utc_datetime)
    end
  end
end
