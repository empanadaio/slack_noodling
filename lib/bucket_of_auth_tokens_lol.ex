defmodule BucketOfAuthTokensLol do
  use Agent

  def start_link(_args) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec store_token(String.t(), String.t()) :: :ok
  def store_token(uid, token) do
    Agent.update(__MODULE__, fn tokens -> Map.put(tokens, uid, token) end)
  end

  @spec get_token(String.t()) :: {:ok, String.t()} | {:error, :no_saved_token}
  def get_token(uid) do
    case Agent.get(__MODULE__, fn tokens -> Map.get(tokens, uid) end) do
      nil -> {:error, :no_saved_token}
      token -> {:ok, token}
    end
  end
end
