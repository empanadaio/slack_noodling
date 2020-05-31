defmodule SlackNoodling.Slack do
  @api "https://slack.com/api"

  @type parse_error :: {:error, Jason.DecodeError}
  @type http_error :: {:error, HTTPoison.Error}
  @type api_error :: {:error, String.t()} | http_error | parse_error

  @spec get_access_token(String.t()) :: {:ok, String.t(), String.t()} | api_error
  def get_access_token(code) do
    id = client_id()
    secret = client_secret()
    url = "#{@api}/oauth.v2.access?client_id=#{id}&client_secret=#{secret}&code=#{code}"

    case get(url) do
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
      {:ok, %{"authed_user" => %{"id" => user_id, "access_token" => access_token}}} ->
        {:ok, user_id, access_token}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec send_message(String.t(), map) :: :ok | api_error
  def send_message(access_token, %{
        "channel_id" => chan,
        "user_name" => user,
        "text" => text,
        "token" => token
      }) do
    url = "#{@api}/chat.postMessage"

    body = %{
      username: user,
      channel: chan,
      text: text,
      token: token
    }

    headers = authenticated_headers(access_token)

    case post(url, body, headers) do
      {:ok, _} ->
        :ok

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec post(String.t(), map, list) :: {:ok, map} | api_error
  defp(post(url, body, headers)) do
    case HTTPoison.post(url, Jason.encode!(body), headers) do
      {:ok, %{status_code: 200, body: body}} ->
        parse_response(body)

      {:ok, %{status_code: code, body: error_body}} ->
        IO.inspect(error_body,
          label: "failed to post to #{url} #{code} body: #{body} headers: #{headers}"
        )

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec get(String.t()) :: {:ok, map} | api_error
  defp get(url) do
    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        parse_response(body)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec parse_response(String.t()) :: {:ok, map} | parse_error | {:error, String.t()}
  defp parse_response(unparsed_body) do
    case Jason.decode(unparsed_body) do
      {:ok, %{"ok" => true} = json} ->
        {:ok, json}

      {:ok, %{"ok" => false, "error" => reason}} ->
        {:error, reason}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec client_id() :: String.t()
  defp client_id() do
    System.fetch_env!("SLACK_OAUTH_CLIENT_ID")
  end

  @spec client_secret() :: String.t()
  defp client_secret() do
    System.fetch_env!("SLACK_OAUTH_CLIENT_SECRET")
  end

  @spec authenticated_headers(String.t()) :: list()
  defp authenticated_headers(auth_token) do
    [
      {"Authorization", "Bearer #{auth_token}"},
      {"Content-type", "application/json"}
    ]
  end
end
