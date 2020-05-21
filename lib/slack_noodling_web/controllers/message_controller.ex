defmodule SlackNoodlingWeb.MessageController do
  use SlackNoodlingWeb, :controller

  def create(conn, params) do
    IO.inspect(params)

    url = "https://hooks.slack.com/services/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"
    headers = [
      {"Content-type", "application/json"}
    ]

    body = %{text: "I handled a warp command."} |> Jason.encode!()
    HTTPoison.post(url, body, headers) |> IO.inspect()

    conn
    |> json(%{ok: "bro"})
  end
end
