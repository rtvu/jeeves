defmodule JeevesWeb.HomeController do
  use JeevesWeb, :controller

  # TODO: uncomment
  # plug(JeevesWeb.Plugs.AuthenticateUser)

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
