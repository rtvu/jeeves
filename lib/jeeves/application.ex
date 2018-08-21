defmodule Jeeves.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Jeeves.Repo, []),
      # Start the endpoint when the application starts
      supervisor(JeevesWeb.Endpoint, []),
      # Start the Presence repository
      supervisor(JeevesWeb.Presence, []),

      supervisor(Registry, [:unique, :print_client_server_registry]),
      supervisor(JeevesWeb.Services.PrintClientDynamicSupervisor, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jeeves.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    JeevesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
