defmodule KM.Output do
  alias Phoenix.HTML.FormData
  use KM.HomeModels

  def submit_request(form_data = %Form{}) do
    # Req.get!()
    # KMWeb.Endpoint.broadcast("chats", "chat_received", [
    #   %{"text" => "I'm ChesterBot!"},
    #   %{"source" => "1"}
    # ])
    first_token =
      form_data.submission
      |> String.split(" ")
      |> List.first()

    if first_token == "Give" do
      [
        %{
          "text" => "PLAN Expansion in the South China Sea and Beyond: A 25-Year Retrospective",
          "source" => "2"
        },
        %{
          "text" =>
            "The past 25 years have witnessed a significant expansion of the People's Liberation Army Navy (PLAN), both regionally and globally.",
          "source" => "3"
        },
        %{
          "source" => nil,
          "text" =>
            "This expansion has been particularly evident in the South China Sea, where China has pursued territorial claims and built its military presence. Here's a historical outline with relevant sources and specific examples:"
        }
      ]
    else
      [
        %{
          "text" =>
            "The methods of levying anti-dumping duties from January 1, 2023, according to the document, involve subjecting importers of non-dispersion-shifted single-mode optical fibers originating from Japan and South Korea to anti-dumping duties. These duties are calculated using an ad valorem method, where the anti-dumping duty amount is determined by multiplying the customs duty-paid price by the applicable anti-dumping duty rate. Additionally, import VAT is assessed on the customs-validated duty-paid price, inclusive of customs duty and anti-dumping duty, serving as the taxable basis. ",
          "source" => "1"
        }
        # %{"text" => "How are you today?", "source" => "2"}
      ]
    end

    # IO.inspect(form_data)
  end
end
