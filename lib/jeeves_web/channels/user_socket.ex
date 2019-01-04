defmodule JeevesWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", JeevesWeb.RoomChannel
  channel "file_explorer:*", JeevesWeb.FileExplorerChannel
  channel "print_client:*", JeevesWeb.PrintClientChannel

  @max_age 24 * 60 * 60
  def connect(%{"token" => token, "client_id" => client_id}, socket) do
    case Phoenix.Token.verify(socket, "user token", token, max_age: @max_age) do
      {:ok, user_id} ->
        user = Jeeves.Accounts.get_user!(user_id)

        socket =  socket
                  |> assign(:current_user_id, user.id)
                  |> assign(:current_username, user.username)
                  |> assign(:current_client_id, client_id)
        {:ok, socket}
      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket) do
    :error
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     JeevesWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
