defmodule SlackNoodling do
  alias SlackNoodling.CommandedApp
  alias SlackNoodling.BsCommand

  def send_bs(aggregate_id, message) do
    CommandedApp.dispatch(%BsCommand{
      bs_id: aggregate_id,
      message: message,
      from_node: Node.self()
    })
  end
end
