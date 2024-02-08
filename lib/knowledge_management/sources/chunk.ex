defmodule KM.Sources.Chunk do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chunks" do
    field :document_id, Ecto.UUID
    field :embedding, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [:document_id, :embedding])
    |> validate_required([:document_id, :embedding])
  end
end
