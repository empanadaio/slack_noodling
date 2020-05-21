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

    auth_token = "xoxb-37173564736-1160830383520-HFtaKVrbukgdqv7pXJWfUtsF"
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
