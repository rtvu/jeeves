defmodule Jeeves.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password_hash, :string)
    field(:is_registered, :boolean, default: false)
    field(:is_administrator, :boolean, default: false)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :is_registered, :is_administrator])
    |> validate_required([:email])
    |> validate_format(:username, ~r/^[a-zA-Z0-9_@.]*$/)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> validate_confirmation(:password)
    |> cast(attrs, [:password])
    |> validate_length(:password, min: 6, max: 36)
    |> encrypt_password()
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
