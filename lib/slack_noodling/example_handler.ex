defmodule SlackNoodling.ExampleHandler do
  use Commanded.Event.Handler,
    application: SlackNoodling.CommandedApp,
    name: "ExampleHandler"

  alias SlackNoodling.Repo
  alias SlackNoodling.Projections.Temp

  @impl true
  def init() do
    IO.inspect({Node.self(), self()}, label: "HANDLER UP")
  end

  @impl true
  def handle(%SlackNoodling.BsEvent{} = event, _metadata) do
    Repo.insert!(%Temp{
      node: Node.self() |> to_string(),
      pid: self() |> :erlang.pid_to_list() |> to_string(),
      event: Map.from_struct(event)
    })

    :ok
  end
end
