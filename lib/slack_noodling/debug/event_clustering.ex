defmodule ExampleEvent do
  @derive Jason.Encoder
  defstruct [:key]
end

# based on https://github.com/commanded/eventstore/blob/master/guides/Cluster.md
defmodule SlackNoodling.Debug.EventClustering do
  use GenServer

  alias EventStore.EventData
  alias SlackNoodling.EventStore

  def send_example_event do
    stream_uuid = UUID.uuid4()

    events = [
      %EventData{
        event_type: "Elixir.ExampleEvent",
        data: %ExampleEvent{key: "value"},
        metadata: %{user: "someuser@example.com"}
      }
    ]

    :ok = EventStore.append_to_stream(stream_uuid, 0, events)
  end

  def list_all_events do
    recorded_events = EventStore.stream_all_forward() |> Enum.to_list()
  end

  def print_events do
    GenServer.call(__MODULE__, :print_events)
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, subscription} = EventStore.subscribe_to_all_streams("debug-subscription", self(), start_from: :origin)
    {:ok, %{subscription: subscription, data: []}}
  end

  @impl true
  def handle_call(:print_events, _from, state) do
    {:reply, state[:data], state}
  end

  @impl true
  def handle_info({:subscribed, subscription}, state) do
    IO.puts("Successfully subscribed to all streams")
    {:noreply, state}
  end

  @impl true
  def handle_info({:events, events}, state) do
    IO.puts("Received events: #{inspect(events)}")
    :ok = EventStore.ack(state[:subscription], events)
    newstate = Map.put(state, :data, events ++ state[:data])
    {:noreply, newstate}
  end
end
