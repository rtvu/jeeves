defmodule JeevesWeb.FileExplorerChannel do
  use Phoenix.Channel

  def join("file_explorer:find", _message, socket) do
    {:ok, socket}
  end

  def join("file_explorer:" <> _else, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("path", %{"path" => path}, socket) do
    full_path = "mount/" <> path <> "/"
    path_crumb = String.split(path, "/")
    {files, folders} = Path.wildcard(full_path <> "*")
            |> Enum.map(&String.replace(&1, full_path, ""))
            |> Enum.split_with(&File.regular?(full_path <> &1))

    {:reply, {:ok, %{path_crumb: path_crumb, files: files, folders: folders}}, socket}
  end
end
