defmodule SlackNoodling.BsEvent do
  @derive Jason.Encoder
  defstruct [
      :bs_id,
      :message,
      :handled_by_node,
      :handled_by_pid,
  ]
end
