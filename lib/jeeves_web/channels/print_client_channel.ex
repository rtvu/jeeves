defmodule JeevesWeb.PrintClientChannel do
  use JeevesWeb, :channel

  alias JeevesWeb.Presence
  alias JeevesWeb.Services.PrintClientDynamicSupervisor
  alias JeevesWeb.Services.PrintClientServer

  def join("print_client:" <> print_client_id, _message, socket) do
    send(self(), :after_join)

    socket =  socket
              |> assign(:current_print_client_id, print_client_id)

    PrintClientDynamicSupervisor.activate(print_client_id)

    {:ok, socket}
  end

  def handle_in("request:username", _message, socket) do
    client_username = socket.assigns[:current_username]

    {:reply, {:ok, %{client_username: client_username}}, socket}
  end

  def handle_in("control:take", _message, socket) do
    print_client_id = socket.assigns[:current_print_client_id]
    client_id = socket.assigns[:current_client_id]
    client_username = socket.assigns[:current_username]
    PrintClientServer.take_control(print_client_id, client_id, client_username)

    {:reply, :ok, socket}
  end

  def handle_in("control:release", _message, socket) do
    print_client_id = socket.assigns[:current_print_client_id]
    client_id = socket.assigns[:current_client_id]
    PrintClientServer.release_control(print_client_id, client_id)

    {:reply, :ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)

    {:ok, _} = Presence.track(socket, "user:#{socket.assigns[:current_user_id]}", %{
      type: "user",
      user_id: socket.assigns[:current_user_id],
      username: socket.assigns[:current_username],
      client_id: socket.assigns[:current_client_id]
    })

    {:noreply, socket}
  end
end
