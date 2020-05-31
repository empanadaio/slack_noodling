defmodule SlackNoodlingWeb.PageView do
  use SlackNoodlingWeb, :view

  def pubsub_debug() do
    SlackNoodling.Debug.PubSub.print_msgs
  end

  def events_debug() do
    SlackNoodling.Debug.EventClustering.print_events
  end
end
