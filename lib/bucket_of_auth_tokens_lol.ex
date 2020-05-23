defmodule BucketOfAuthTokensLol do
  def start_link(_args) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def store_token(token) do
    Agent.update(__MODULE__, fn tokens -> [token | tokens] end)
  end

  def get_tokens() do
    Agent.get(__MODULE__, fn state -> state end)
  end
end

