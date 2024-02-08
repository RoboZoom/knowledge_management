defmodule KM.Output do
  use KM.HomeModels

  def submit_request(form_data = %Form{}) do
    # Req.get!()
    KMWeb.Endpoint.broadcast("chats", "chat_received", [
      %{"text" => "I'm ChesterBot!"},
      %{"source" => "1"}
    ])

    IO.inspect(form_data)
  end
end
