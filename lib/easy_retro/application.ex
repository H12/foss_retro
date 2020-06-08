defmodule EasyRetro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      EasyRetroWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EasyRetro.PubSub},
      # Start the Endpoint (http/https)
      EasyRetroWeb.Endpoint,
      # Start a worker by calling: EasyRetro.Worker.start_link(arg)
      # {EasyRetro.Worker, arg}
 
      # Custom applications for handling creation/usage/removal of retro boards
      {EasyRetro.Boundary.BoardManager, name: EasyRetro.Boundary.BoardManager}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EasyRetro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EasyRetroWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
