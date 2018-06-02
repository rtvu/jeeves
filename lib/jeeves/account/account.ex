defmodule Jeeves.Account do
  alias Jeeves.Repo
  alias Jeeves.Account.User

  def sign_in(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && user.password_hash == password ->
        {:ok, user}

      true ->
        {:error, :unauthorized}
    end
  end
end
