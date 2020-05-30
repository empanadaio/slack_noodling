defmodule SlackNoodlingWeb.MessageController do
  use SlackNoodlingWeb, :controller

  def create(conn, params) do
    IO.inspect(params)

    # %{
    #   "channel_id" => "G0140U94QH0",
    #   "channel_name" => "privategroup",
    #   "command" => "/warp",
    #   "response_url" => "https://hooks.slack.com/commands/T1353GLMN/1140895526165/kMeno7Y17hyXBNjSz9lP8nPA",
    #   "team_domain" => "bitfield-co",
    #   "team_id" => "T1353GLMN",
    #   "text" => "test2",
    #   "token" => "YPHHk1Ng5ZPBuP3h4mGGfkG3",
    #   "trigger_id" => "1142483564083.37173564736.17757494c59212b07fbdbb70dc0f86d2",
    #   "user_id" => "U1354V28P",
    #   "user_name" => "ben"
    # }

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

    # {
    # 	"ok": true,
    # 	"app_id": "A013L7D537Z",
    # 	"authed_user": {
    # 		"id": "U1354V28P",
    # 		"scope": "chat:write",
    # 		"access_token": "xoxp-37173564736-37174988295-1143033407683-3ace622d57c0923341ae3d7263994931",
    # 		"token_type": "user"
    # 	},
    # 	"scope": "commands,chat:write.public,chat:write",
    # 	"token_type": "bot",
    # 	"access_token": "xoxb-37173564736-1160830383520-ILegXonUjIWyCInma2CCroR2",
    # 	"bot_user_id": "U014QQEB9FA",
    # 	"team": {
    # 		"id": "T1353GLMN",
    # 		"name": "Bitfield"
    # 	},
    # 	"enterprise": null
    # }
    case(HTTPoison.get!(url) |> IO.inspect(label: "auth response")) do
      %{status_code: 200, body: body} ->
        %{"authed_user" => %{"id" => uid, "access_token" => token}} = Jason.decode!(body)

        # remember the token for this user on this app, etc
        BucketOfAuthTokensLol.store_token(uid, token)

      error ->
        IO.inspect(error)
        raise "Fuck'd 'er bud"
    end

    conn
    |> text("OK?")
  end

  defp send_as_user(%{
         "channel_id" => chan,
         "user_id" => uid,
         "user_name" => user,
         "text" => text,
         "token" => token
       }) do
    url = "https://slack.com/api/chat.postMessage"

    auth_token = BucketOfAuthTokensLol.get_token(uid)

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
