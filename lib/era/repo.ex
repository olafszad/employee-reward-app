defmodule Era.Repo do
  use Ecto.Repo,
    otp_app: :era,
    adapter: Ecto.Adapters.Postgres
end
