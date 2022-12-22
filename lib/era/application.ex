defmodule Era.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Era.Repo,
      # Start the Telemetry supervisor
      EraWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Era.PubSub},
      # Start the Endpoint (http/https)
      EraWeb.Endpoint
      # Start a worker by calling: Era.Worker.start_link(arg)
      # {Era.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Era.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
