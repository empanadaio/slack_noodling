defmodule SlackNoodlingWeb.MessageController do
  use SlackNoodlingWeb, :controller

  def create(conn, params) do
    IO.inspect(params)

    # send_as_bot("hello i'm a bot")
    send_as_user(params)

    conn
    |> json(%{ok: "bro"})
  end

  defp send_as_user(%{ "channel_id" => chan, "user_name" => user, "text" => text, "token" => token}) do
    url = "https://slack.com/api/chat.postMessage"

    auth_token = "xoxp-37173564736-37174988295-1149854095793-882a78512370e6b121b3c751834124eb"

    headers = [
      {"Authorization",  "Bearer #{auth_token}"},
      {"Content-type", "application/json"}
    ]

    body = %{
      username: user,
      channel: chan,
      text: text,
      token: token
    }
    HTTPoison.post(url, Jason.encode!(body), headers) |> IO.inspect()
  end
end
