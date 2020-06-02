defmodule SlackNoodlingWeb.PageView do
  use SlackNoodlingWeb, :view

  def events_debug() do
    SlackNoodling.TempStateBall.get_state()
  end
end
