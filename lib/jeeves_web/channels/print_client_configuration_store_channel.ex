defmodule JeevesWeb.PrintClientConfigurationStoreChannel do
  use Phoenix.Channel

  def join("print_client_configuration_store:channel", _message, socket) do
    {:ok, socket}
  end

  def join("file_explorer:" <> _else, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  # def handle_in("list-path-contents", %{"path" => path}, socket) do
  #   full_path = "mount/" <> path
  #   {files, folders} = Path.wildcard(full_path <> "*")
  #           |> Enum.map(&String.replace(&1, full_path, ""))
  #           |> Enum.split_with(&File.regular?(full_path <> &1))
  #
  #   {:reply, {:ok, %{files: files, folders: folders}}, socket}
  # end
  #
  # def handle_in("does-file-exist", %{"path" => path}, socket) do
  #   full_path = "mount/" <> path
  #   exists = File.regular?(full_path)
  #
  #   {:reply, {:ok, %{exists: exists}}, socket}
  # end
end
