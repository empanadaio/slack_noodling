defmodule SlackNoodling.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      SlackNoodling.CommandedApp,
      # Start the Ecto repository
      SlackNoodling.Repo,
      # Start the EventStore
      # SlackNoodling.EventStore,
      # Start the Telemetry supervisor
      SlackNoodlingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SlackNoodling.PubSub},
      # Start the Endpoint (http/https)
      SlackNoodlingWeb.Endpoint,
      SlackNoodling.InMemoryTokenStore,
      # SlackNoodling.Debug.PubSub,
      # SlackNoodling.Debug.EventClustering,
      # Start a worker by calling: SlackNoodling.Worker.start_link(arg)
      # {SlackNoodling.Worker, arg}

      # libcluster
      {Cluster.Supervisor, [topologies, [name: SlackNoodling.ClusterSupervisor]]},

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
