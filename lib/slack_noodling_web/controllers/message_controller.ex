defmodule SlackNoodlingWeb.MessageController do
  use SlackNoodlingWeb, :controller

  def create(conn, params) do
    IO.inspect(params)

    # send_as_bot("hello i'm a bot")
    send_as_user(params)

    conn
    |> json(%{ok: "bro"})
  end

  def add_to_slack(conn, params) do
    IO.inspect(params, label: "add_to_slack")

    #  client_id - issued when you created your app (required)
    #  scope - permissions to request (see below) (required)
    #  redirect_uri - URL to redirect back to (see below) (optional)
    #  state - unique string to be passed back upon completion (optional)
    #  team - Slack team ID of a workspace to attempt to restrict to (optional)
    client_id = System.get_env("SLACK_OAUTH_CLIENT_ID")

    scope = "chat:write"
    redirect = "https://warp.gigalixirapp.com/oauth/callback"
    state = "123state"

    url =
      "https://slack.com/oauth/authorize?client_id=#{client_id}&scope=#{scope}&redirect_uri=#{
        redirect
      }&state=#{state}"

    HTTPoison.get!(url) |> IO.inspect()

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
