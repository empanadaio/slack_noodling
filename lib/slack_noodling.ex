defmodule SlackNoodling do
  alias SlackNoodling.CommandedApp
  alias SlackNoodling.BsCommand

  @aggregate_a "aggregate_a"
  @aggregate_b "aggregate_b"

  def send_to_a(message) do
    CommandedApp.dispatch(%BsCommand{
      bs_id: @aggregate_a,
      message: message,
      from_node: Node.self()
    })
  end

  def send_to_b(message) do
    CommandedApp.dispatch(%BsCommand{
      bs_id: @aggregate_b,
      message: message,
      from_node: Node.self()
    })
  end
end
