defmodule SlackNoodlingWeb.PageController do
  use SlackNoodlingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def debug(conn, _params) do
    render(conn, "debug.html")
  end
end
