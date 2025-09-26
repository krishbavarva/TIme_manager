defmodule GothamScheduler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GothamSchedulerWeb.Telemetry,
      GothamScheduler.Repo,
      {DNSCluster, query: Application.get_env(:gotham_scheduler, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GothamScheduler.PubSub},
      # Start a worker by calling: GothamScheduler.Worker.start_link(arg)
      # {GothamScheduler.Worker, arg},
      # Start to serve requests, typically the last entry
      GothamSchedulerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GothamScheduler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GothamSchedulerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
