defmodule JeevesWeb.Plugs.AuthenticateAdminUser do
  import Plug.Conn
  import Phoenix.Controller
  import JeevesWeb.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.current_user.is_administrator do
      conn
    else
      conn
      |> put_flash(:error, "You need to be an administrator to view page.")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end
end
