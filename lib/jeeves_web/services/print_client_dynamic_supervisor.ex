defmodule JeevesWeb.Services.PrintClientDynamicSupervisor do
  use DynamicSupervisor

  alias JeevesWeb.Services.PrintClientServer

  @print_client_server_registry_name :print_client_server_registry

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def activate(print_client_id) do
    case Registry.lookup(@print_client_server_registry_name, print_client_id) do
      [] ->
        start_child(print_client_id)
        nil
      _ ->
        nil
    end
  end

  def init([]) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp start_child(print_client_id) do
    child_spec = {PrintClientServer, print_client_id}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
