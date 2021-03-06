defmodule JeevesWeb.SessionController do
  use JeevesWeb, :controller

  alias Jeeves.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Accounts.validate_user_credentials(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "You have successfully signed in!")
        |> redirect(to: Routes.home_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid Email or Password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
