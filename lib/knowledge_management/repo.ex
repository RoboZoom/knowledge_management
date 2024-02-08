defmodule KM.Repo do
  use Ecto.Repo,
    otp_app: :knowledge_management,
    adapter: Ecto.Adapters.Postgres
end
