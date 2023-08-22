defmodule Vesta.Repo do
  use Ecto.Repo,
    otp_app: :vesta,
    adapter: Ecto.Adapters.Postgres
end
