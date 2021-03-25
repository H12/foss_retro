defmodule FossRetro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FossRetroWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FossRetro.PubSub},
      # Start the Endpoint (http/https)
      FossRetroWeb.Endpoint,
      # Start a worker by calling: FossRetro.Worker.start_link(arg)
      # {FossRetro.Worker, arg}

      # Custom applications for handling creation/usage/removal of retro boards
      {FossRetro.Boundary.BoardManager, [name: FossRetro.Boundary.BoardManager]},
      {Registry, [name: FossRetro.Registry.BoardSession, keys: :unique]},
      {DynamicSupervisor, [name: FossRetro.Supervisor.BoardSession, strategy: :one_for_one]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FossRetro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FossRetroWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
