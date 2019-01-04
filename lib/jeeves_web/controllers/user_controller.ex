defmodule JeevesWeb.UserController do
  use JeevesWeb, :controller

  alias Jeeves.Accounts

  plug(JeevesWeb.Plugs.AuthenticateUser)

  def edit(conn, %{"username" => username}) do
    user = Accounts.get_by_username!(username)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", username: username, changeset: changeset)
  end

  def update(conn, %{"username" => username, "user" => user_params}) do
    user = Accounts.get_by_username!(username)

    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.home_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", username: username, changeset: changeset)
    end
  end
end
