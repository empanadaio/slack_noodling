defmodule SlackNoodling.ExampleHandler do
  use Commanded.Event.Handler,
    application: SlackNoodling.CommandedApp,
    name: "ExampleHandler"

  def handle(%SlackNoodling.BsEvent{} = event, _metadata) do
    SlackNoodling.TempStateBall.record_event(event, Node.self(), self())
    :ok
  end
end
