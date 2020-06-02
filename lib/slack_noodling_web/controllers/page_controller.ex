defmodule SlackNoodlingWeb.PageController do
  use SlackNoodlingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def debug(conn, _params) do
    render(conn, "debug.html")
  end

  def send_to_a(conn, _params) do
    SlackNoodling.send_to_a("Weee")

    conn
    |> redirect(to: Routes.page_path(conn, :debug))
  end

  def send_to_b(conn, _params) do
    SlackNoodling.send_to_b("Weee")

    conn
    |> redirect(to: Routes.page_path(conn, :debug))
  end
end
