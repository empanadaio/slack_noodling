defmodule SlackNoodling.BsAggregate do
  @derive Jason.Encoder
  defstruct [:bs_id, messages: []]

  alias __MODULE__, as: Bullshit

  def execute(%Bullshit{}, %SlackNoodling.BsCommand{} = command) do
    %SlackNoodling.BsEvent{
      bs_id: command.bs_id,
      message: command.message,
      from_node: command.from_node,
      handled_by_node: Node.self(),
      handled_by_pid: :erlang.pid_to_list(self())
    }
  end

  def apply(%Bullshit{} = state, %SlackNoodling.BsEvent{} = event) do
    %{state | messages: state.messages ++ [event.message]}
  end
end
