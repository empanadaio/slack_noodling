defmodule SlackNoodling.InMemoryTokenStore do
  use Agent

  def start_link(_args) do
    Agent.start_link(fn -> %{} end, name: {:global, __MODULE__})
  end

  @spec store_token(String.t(), String.t()) :: :ok
  def store_token(uid, token) do
    Agent.update(__MODULE__, fn store -> put(store, uid, token) end)
  end

  @spec get_token(String.t()) :: {:ok, String.t()} | {:error, :no_saved_token}
  def get_token(uid) do
    case Agent.get(__MODULE__, fn store -> get(store, uid) end) do
      nil -> {:error, :no_saved_token}
      token -> {:ok, token}
    end
  end

  defp put(store, user_id, access_token) do
    IO.inspect(put: store, user_id: user_id, access_token: access_token)
    Map.put(store, user_id, access_token)
  end

  defp get(store, user_id) do
    access_token = Map.get(store, user_id)
    IO.inspect(get: store, user_id: user_id, access_token: access_token)
    access_token
  end
end
