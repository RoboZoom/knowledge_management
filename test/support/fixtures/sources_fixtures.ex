defmodule KM.SourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `KM.Sources` context.
  """

  @doc """
  Generate a source.
  """
  def source_fixture(attrs \\ %{}) do
    {:ok, source} =
      attrs
      |> Enum.into(%{
        areas_of_interest: "some areas_of_interest",
        classification: "some classification",
        date: ~D[2024-02-06],
        keywords: "some keywords",
        organization: "some organization",
        page_count: "some page_count",
        region: "some region",
        scanned_by: "some scanned_by",
        title: "some title",
        type: "some type"
      })
      |> KM.Sources.create_source()

    source
  end

  @doc """
  Generate a chunk.
  """
  def chunk_fixture(attrs \\ %{}) do
    {:ok, chunk} =
      attrs
      |> Enum.into(%{
        document_id: "7488a646-e31f-11e4-aace-600308960662",
        embedding: "some embedding"
      })
      |> KM.Sources.create_chunk()

    chunk
  end
end
