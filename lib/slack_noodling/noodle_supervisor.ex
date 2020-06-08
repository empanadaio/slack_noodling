defmodule SlackNoodling.NoodleSupervisor do
  use Supervisor

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, nil)
  end

  @impl true
  def init(_args) do
    children = [
      SlackNoodling.ExampleHandler
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
