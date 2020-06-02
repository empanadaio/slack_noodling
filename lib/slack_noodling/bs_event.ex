defmodule SlackNoodling.BsEvent do
  @derive Jason.Encoder
  defstruct [
    :bs_id,
    :message,
    :from_node,
    :handled_by_node,
    :handled_by_pid
  ]
end
