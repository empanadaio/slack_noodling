defmodule SlackNoodlingWeb.MessageController do
  use SlackNoodlingWeb, :controller

  def create(conn, params) do
    IO.inspect(params)

    # send_as_bot("hello i'm a bot")
    send_as_user(params)

    conn
    |> json(%{ok: "bro"})
  end

  def add_to_slack(conn, %{"code" => code}) do
    IO.inspect(code, label: "add_to_slack_callback")

    client_id = System.fetch_env!("SLACK_OAUTH_CLIENT_ID")
    client_secret = System.fetch_env!("SLACK_OAUTH_CLIENT_SECRET")

    url =
      "https://slack.com/api/oauth.v2.access?client_id=#{client_id}&client_secret=#{client_secret}&code=#{
        code
      }"

    HTTPoison.get!(url) |> IO.inspect(label: "auth response")

    conn
    |> text("OK?")
  end

  defp send_as_user(%{"channel_id" => chan, "user_name" => user, "text" => text, "token" => token}) do
    url = "https://slack.com/api/chat.postMessage"

    auth_token = System.get_env("SLACK_OAUTH_ACCESS_TOKEN")

    headers = [
      {"Authorization", "Bearer #{auth_token}"},
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
