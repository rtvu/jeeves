defmodule JeevesWeb.Plugs.AuthenticateAdminUser do
  import Plug.Conn
  import Phoenix.Controller
  alias JeevesWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.current_user.is_administrator do
      conn
    else
      conn
      |> put_flash(:error, "You need to be an administrator to view page.")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
