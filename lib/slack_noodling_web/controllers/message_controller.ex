defmodule SlackNoodlingWeb.MessageController do
  use SlackNoodlingWeb, :controller

  alias SlackNoodling.Slack

  def add_to_slack(conn, %{"code" => code}) do
    case Slack.get_access_token(code) do
      {:ok, user_id, access_token} ->
        BucketOfAuthTokensLol.store_token(user_id, access_token)

        conn
        |> text("Thank you, you have been authenticated")

      {:error, reason} ->
        IO.inspect(reason, label: "failed to authenticate user against slack")

        conn
        |> put_status(403)
        |> text("We could not authenticate you")
    end
  end

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
  def create(conn, %{"user_id" => user_id} = params) do
    with {:ok, access_token} <- BucketOfAuthTokensLol.get_token(user_id),
         :ok <- Slack.send_message(access_token, params) do
      conn
      |> put_status(204)
      |> text("")
    else
      {:error, reason} ->
        IO.inspect(reason, label: "Failed to warp message")

        conn
        |> put_status(403)
        |> text(inspect(reason))
    end
  end
end
