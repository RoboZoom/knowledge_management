defmodule KM.SourcesTest do
  use KM.DataCase

  alias KM.Sources

  describe "sources" do
    alias KM.Sources.Source

    import KM.SourcesFixtures

    @invalid_attrs %{type: nil, date: nil, title: nil, keywords: nil, organization: nil, classification: nil, areas_of_interest: nil, region: nil, page_count: nil, scanned_by: nil}

    test "list_sources/0 returns all sources" do
      source = source_fixture()
      assert Sources.list_sources() == [source]
    end

    test "get_source!/1 returns the source with given id" do
      source = source_fixture()
      assert Sources.get_source!(source.id) == source
    end

    test "create_source/1 with valid data creates a source" do
      valid_attrs = %{type: "some type", date: ~D[2024-02-06], title: "some title", keywords: "some keywords", organization: "some organization", classification: "some classification", areas_of_interest: "some areas_of_interest", region: "some region", page_count: "some page_count", scanned_by: "some scanned_by"}

      assert {:ok, %Source{} = source} = Sources.create_source(valid_attrs)
      assert source.type == "some type"
      assert source.date == ~D[2024-02-06]
      assert source.title == "some title"
      assert source.keywords == "some keywords"
      assert source.organization == "some organization"
      assert source.classification == "some classification"
      assert source.areas_of_interest == "some areas_of_interest"
      assert source.region == "some region"
      assert source.page_count == "some page_count"
      assert source.scanned_by == "some scanned_by"
    end

    test "create_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sources.create_source(@invalid_attrs)
    end

    test "update_source/2 with valid data updates the source" do
      source = source_fixture()
      update_attrs = %{type: "some updated type", date: ~D[2024-02-07], title: "some updated title", keywords: "some updated keywords", organization: "some updated organization", classification: "some updated classification", areas_of_interest: "some updated areas_of_interest", region: "some updated region", page_count: "some updated page_count", scanned_by: "some updated scanned_by"}

      assert {:ok, %Source{} = source} = Sources.update_source(source, update_attrs)
      assert source.type == "some updated type"
      assert source.date == ~D[2024-02-07]
      assert source.title == "some updated title"
      assert source.keywords == "some updated keywords"
      assert source.organization == "some updated organization"
      assert source.classification == "some updated classification"
      assert source.areas_of_interest == "some updated areas_of_interest"
      assert source.region == "some updated region"
      assert source.page_count == "some updated page_count"
      assert source.scanned_by == "some updated scanned_by"
    end

    test "update_source/2 with invalid data returns error changeset" do
      source = source_fixture()
      assert {:error, %Ecto.Changeset{}} = Sources.update_source(source, @invalid_attrs)
      assert source == Sources.get_source!(source.id)
    end

    test "delete_source/1 deletes the source" do
      source = source_fixture()
      assert {:ok, %Source{}} = Sources.delete_source(source)
      assert_raise Ecto.NoResultsError, fn -> Sources.get_source!(source.id) end
    end

    test "change_source/1 returns a source changeset" do
      source = source_fixture()
      assert %Ecto.Changeset{} = Sources.change_source(source)
    end
  end

  describe "chunks" do
    alias KM.Sources.Chunk

    import KM.SourcesFixtures

    @invalid_attrs %{document_id: nil, embedding: nil}

    test "list_chunks/0 returns all chunks" do
      chunk = chunk_fixture()
      assert Sources.list_chunks() == [chunk]
    end

    test "get_chunk!/1 returns the chunk with given id" do
      chunk = chunk_fixture()
      assert Sources.get_chunk!(chunk.id) == chunk
    end

    test "create_chunk/1 with valid data creates a chunk" do
      valid_attrs = %{document_id: "7488a646-e31f-11e4-aace-600308960662", embedding: "some embedding"}

      assert {:ok, %Chunk{} = chunk} = Sources.create_chunk(valid_attrs)
      assert chunk.document_id == "7488a646-e31f-11e4-aace-600308960662"
      assert chunk.embedding == "some embedding"
    end

    test "create_chunk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sources.create_chunk(@invalid_attrs)
    end

    test "update_chunk/2 with valid data updates the chunk" do
      chunk = chunk_fixture()
      update_attrs = %{document_id: "7488a646-e31f-11e4-aace-600308960668", embedding: "some updated embedding"}

      assert {:ok, %Chunk{} = chunk} = Sources.update_chunk(chunk, update_attrs)
      assert chunk.document_id == "7488a646-e31f-11e4-aace-600308960668"
      assert chunk.embedding == "some updated embedding"
    end

    test "update_chunk/2 with invalid data returns error changeset" do
      chunk = chunk_fixture()
      assert {:error, %Ecto.Changeset{}} = Sources.update_chunk(chunk, @invalid_attrs)
      assert chunk == Sources.get_chunk!(chunk.id)
    end

    test "delete_chunk/1 deletes the chunk" do
      chunk = chunk_fixture()
      assert {:ok, %Chunk{}} = Sources.delete_chunk(chunk)
      assert_raise Ecto.NoResultsError, fn -> Sources.get_chunk!(chunk.id) end
    end

    test "change_chunk/1 returns a chunk changeset" do
      chunk = chunk_fixture()
      assert %Ecto.Changeset{} = Sources.change_chunk(chunk)
    end
  end
end
