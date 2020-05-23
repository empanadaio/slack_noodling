defmodule SlackNoodling.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      SlackNoodling.Repo,
      # Start the Telemetry supervisor
      SlackNoodlingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SlackNoodling.PubSub},
      # Start the Endpoint (http/https)
      SlackNoodlingWeb.Endpoint,
      BucketOfAuthTokensLol
      # Start a worker by calling: SlackNoodling.Worker.start_link(arg)
      # {SlackNoodling.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SlackNoodling.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SlackNoodlingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
