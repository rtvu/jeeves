# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Jeeves.Repo.insert!(%Jeeves.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# password = Comeonin.Bcrypt.hashpwsalt("password")

%Jeeves.Accounts.User{}
|> Jeeves.Accounts.User.registration_changeset(%{
  email: "user@example.com",
  password: "password",
  password_confirmation: "password"
})
|> Jeeves.Repo.insert()

%Jeeves.Accounts.User{}
|> Jeeves.Accounts.User.registration_changeset(%{
  email: "ryan@example.com",
  password: "password",
  password_confirmation: "passwords"
})
|> Jeeves.Repo.insert()
