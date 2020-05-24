defmodule BucketOfAuthTokensLol do
  use Agent

  def start_link(_args) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def store_token(uid, token) do
    Agent.update(__MODULE__, fn tokens -> Map.put(tokens, uid, token) end)
  end

  def get_token(uid) do
    Agent.get(__MODULE__, fn tokens -> Map.get(tokens, uid) end)
  end
end

