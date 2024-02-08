defmodule KM.Output do
  use KM.HomeModels

  def submit_request(form_data = %Form{}) do
    Req.get!()


  end
end
