defmodule SlackNoodling.CommandedApp do
  use Commanded.Application,
    otp_app: :slack_noodling,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: SlackNoodling.EventStore
    ],
    registry: :global

  router(SlackNoodling.BsRouter)
end
