defmodule SlackNoodling.TempStateBall do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  def record_event(event, node, pid) do
    GenServer.call(__MODULE__, {:store, event, node, pid})
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:store, event, node, pid}, _from, state) do
    new_state = [{event, node, pid} | state]
    {:reply, :ok, new_state}
  end
end
