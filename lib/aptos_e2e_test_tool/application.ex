defmodule AptosE2eTestTool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AptosE2eTestToolWeb.Telemetry,
      # Start the Ecto repository
      AptosE2eTestTool.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: AptosE2eTestTool.PubSub},
      # Start Finch
      {Finch, name: AptosE2eTestTool.Finch},
      # Start the Endpoint (http/https)
      AptosE2eTestToolWeb.Endpoint
      # Start a worker by calling: AptosE2eTestTool.Worker.start_link(arg)
      # {AptosE2eTestTool.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AptosE2eTestTool.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AptosE2eTestToolWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
