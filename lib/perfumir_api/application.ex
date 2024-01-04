defmodule PerfumirApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PerfumirApiWeb.Telemetry,
      PerfumirApi.Repo,
      {DNSCluster, query: Application.get_env(:perfumir_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PerfumirApi.PubSub},
      # Start a worker by calling: PerfumirApi.Worker.start_link(arg)
      # {PerfumirApi.Worker, arg},
      # Start to serve requests, typically the last entry
      PerfumirApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PerfumirApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PerfumirApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
