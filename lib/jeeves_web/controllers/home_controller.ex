defmodule JeevesWeb.HomeController do
  use JeevesWeb, :controller

  plug(JeevesWeb.Plugs.AuthenticateUser)

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
