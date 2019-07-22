defmodule Jeeves.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Jeeves.Repo,
      # Start the endpoint when the application starts
      JeevesWeb.Endpoint,
      # Start the Presence repository
      JeevesWeb.Presence,

      {Registry, keys: :unique, name: :print_client_server_registry},
      Jeeves.PrintClient.DynamicSupervisor,
      Jeeves.PrintClient.ConfigurationStoreServer
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
