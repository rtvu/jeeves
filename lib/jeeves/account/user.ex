defmodule Jeeves.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password_hash, :string)
    field(:is_registered, :boolean, default: false)
    field(:is_administrator, :boolean, default: false)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password_hash, :is_registered, :is_administrator])
    |> validate_required([:username, :email, :password_hash, :is_registered, :is_administrator])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  @doc false
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email)
  end
end
