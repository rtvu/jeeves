defmodule Jeeves.Account do
  alias Jeeves.Repo
  alias Jeeves.Account.User

  def validate_credentials(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Comeonin.Bcrypt.checkpw(password, user.password_hash) ->
        {:ok, user}

      true ->
        {:error, :unauthorized}
    end
  end

  def register(params) do
    User.registration_changeset(%User{}, params) |> Repo.insert()
  end
end
