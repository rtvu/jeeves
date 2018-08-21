defmodule JeevesWeb.Services.PrintClientServer do
  use GenServer, restart: :transient

  defstruct [print_client_id: nil, topic: nil, key: nil, controlling_client_id: nil, state: nil]

  @print_client_server_registry_name :print_client_server_registry

  def start_link(print_client_id) do
    GenServer.start_link(__MODULE__, print_client_id, name: via_tuple(print_client_id))
  end

  defp via_tuple(print_client_id) do
    {:via, Registry, {@print_client_server_registry_name, print_client_id}}
  end

  def take_control(print_client_id, client_id, client_username) do
    GenServer.call(via_tuple(print_client_id), {:take_control, client_id, client_username})
  end

  def release_control(print_client_id, client_id) do
    GenServer.call(via_tuple(print_client_id), {:release_control, client_id})
  end

  def init(print_client_id) do
    state = %__MODULE__{
      print_client_id: print_client_id,
      topic: "print_client:" <> print_client_id,
      key: "print_client:" <> print_client_id,
      controlling_client_id: "",
      state: %{
        "type" => "print_client",
        "print_client_id" => print_client_id,
        "controlling_client_id" => "",
        "controlling_client_username" => ""
      }
    }
    JeevesWeb.Endpoint.subscribe(state.topic)
    JeevesWeb.Presence.track(self(), state.topic, state.key, state.state)
    {:ok, state}
  end

  def handle_call({:take_control, client_id, client_username}, _from, state) do
    state = %{state | controlling_client_id: client_id,
                      state: %{state.state | "controlling_client_id" => client_id,
                                             "controlling_client_username" => client_username
                             }
            }

    JeevesWeb.Endpoint.broadcast!(state.topic, "control:controlling_client_id", %{controlling_client_id: state.controlling_client_id})
    JeevesWeb.Presence.update(self(), state.topic, state.key, state.state)

    {:reply, :ok, state}
  end

  def handle_call({:release_control, client_id}, _from, state) do
    state =
      if (state.controlling_client_id == client_id) do
        %{state | controlling_client_id: "",
                  state: %{state.state | "controlling_client_id" => "",
                                         "controlling_client_username" => ""
                         }
        }
      else
        state
      end

    JeevesWeb.Endpoint.broadcast!(state.topic, "control:controlling_client_id", %{controlling_client_id: state.controlling_client_id})
    JeevesWeb.Presence.update(self(), state.topic, state.key, state.state)

    {:reply, :ok, state}
  end

  def handle_info(msg, state) do
    IO.inspect(msg)
    {:noreply, state}
  end
end
