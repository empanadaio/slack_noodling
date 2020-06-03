defmodule SlackNoodlingWeb.PageController do
  use SlackNoodlingWeb, :controller

  import Ecto.Query

  alias SlackNoodling.Repo
  alias SlackNoodling.Projections.Temp

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def debug(conn, _params) do
    events = Repo.all(from t in Temp, select: t, order_by: [desc: t.inserted_at])
    render(conn, "debug.html", events: events)
  end

  def create_message_from_api(conn, %{"to" => aggregate_id, "body" => message}) do
    SlackNoodling.send_bs(aggregate_id, message)

    conn
    |> put_status(204)
    |> json(%{ok: true})
  end

  def create_message(conn, %{"message" => %{"to" => aggregate_id, "body" => message}}) do
    SlackNoodling.send_bs(aggregate_id, message)

    conn
    |> redirect(to: Routes.page_path(conn, :debug))
  end
end
