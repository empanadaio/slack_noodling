defmodule SlackNoodling.Repo do
  use Ecto.Repo,
    otp_app: :slack_noodling,
    adapter: Ecto.Adapters.Postgres
end
