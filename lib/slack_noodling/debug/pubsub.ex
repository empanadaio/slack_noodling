defmodule  SlackNoodling.Debug.PubSub do
  use GenServer
  @debug_topic "debug:pubsub"

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def print_msgs() do
    GenServer.call(__MODULE__, :print_msgs)
  end

  def broadcast_debug_msg(msg) do
    Phoenix.PubSub.broadcast!(SlackNoodling.PubSub, @debug_topic, msg)
  end

  @impl true
  def init(_) do
    Phoenix.PubSub.subscribe(SlackNoodling.PubSub, @debug_topic)
    {:ok, []}
  end

  @impl true
  def handle_call(:print_msgs, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(msg, state) do
    msg_with_context = {Node.self, self(), msg}
    newstate = [msg_with_context | state]
    {:noreply, newstate}
  end
end
