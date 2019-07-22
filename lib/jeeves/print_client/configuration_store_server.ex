defmodule Jeeves.PrintClient.ConfigurationStoreServer do
  use GenServer

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def refresh() do
    GenServer.cast(__MODULE__, :refresh)
  end

  def query() do
    GenServer.call(__MODULE__, :query)
  end

  # Server

  def init(_) do
    state = get_print_client_configs()
    {:ok, state}
  end

  def handle_cast(:refresh, _state) do
    state = get_print_client_configs()
    {:noreply, state}
  end

  def handle_call(:query, _from, state) do
    {:reply, state, state}
  end

  # Private

  defp get_print_client_configs() do
    path = Path.expand("../../../experimental/print_client_configs/", __DIR__)

    path
    |> File.ls!()
    |> Enum.filter(
         &(!File.dir?(path <> &1))
       )
    |> Enum.sort()
  end
end
