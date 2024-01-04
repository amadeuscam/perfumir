defmodule PerfumirApi.Repo do
  use Ecto.Repo,
    otp_app: :perfumir_api,
    adapter: Ecto.Adapters.Postgres
end
