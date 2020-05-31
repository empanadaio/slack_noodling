defmodule SlackNoodlingWeb.PageView do
  use SlackNoodlingWeb, :view

  def pubdebug() do
    SlackNoodling.Debug.PubSub.print_msgs
  end
end
