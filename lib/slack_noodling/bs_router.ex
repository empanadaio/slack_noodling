defmodule SlackNoodling.BsRouter do
  use Commanded.Commands.Router

  alias SlackNoodling.BsCommand
  alias SlackNoodling.BsAggregate

  dispatch([BsCommand], to: BsAggregate, identity: :bs_id)
end
