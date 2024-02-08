defmodule KM.GetSources do
  alias KM.Sources.Source

  def get_sources(ids) do
    IO.inspect(ids)

    ids
    |> IO.inspect()
    |> Enum.map(&get_source(&1))
    |> IO.inspect()
    |> Enum.filter(fn x -> x !== nil end)
  end

  def get_source(id) do
    sources = get_source_list()
    Enum.find(sources, &(&1.id == id))
    # %Source{
    #   id: id,
    #   type: "Announcement",
    #   region: "China",
    #   title:
    #     "MOFCOM Announcement No. 37 of 2022 Announcement on the Ruling on the End-of-Term Review of Anti-Dumping Measures Applied to Imports of Non-Dispersion Shifted Single-Mode Optical Fibers Originating in Japan and the Republic of Korea"
    # }
  end

  def get_source_list() do
    [
      %Source{
        id: "1",
        type: "Announcement",
        region: "China",
        title:
          "MOFCOM Announcement No. 37 of 2022 Announcement on the Ruling on the End-of-Term Review of Anti-Dumping Measures Applied to Imports of Non-Dispersion Shifted Single-Mode Optical Fibers Originating in Japan and the Republic of Korea"
      },
      %Source{
        id: "2",
        type: "Article",
        region: "China",
        organization: "GSIS",
        title: "Predictions - PLAN ships in service by 2030"
      },
      %Source{
        id: "3",
        type: "Article",
        region: "China",
        organization: "CSIS",
        title: "How is China modernizing its Navy"
      },
      %Source{
        id: "4",
        type: "Article",
        region: "China",
        title: "China Naval Modernization: Implications for
U.S. Navy Capabilities—Background and
Issues for Congress"
      }
    ]
  end
end
