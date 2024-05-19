defmodule ListenToo.Repo do
  use Ecto.Repo,
    otp_app: :listen_too,
    adapter: Ecto.Adapters.Postgres
end
