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

Jeeves.Accounts.register_user(%{
  username: "user",
  email: "user@example.com",
  password: "password",
  password_confirmation: "password",
  is_registered: true,
  is_administrator: true
})

Jeeves.Accounts.register_user(%{
  username: "user",
  email: "ryan@example.com",
  password: "password",
  password_confirmation: "passwords"
})

Jeeves.Accounts.register_user(%{
  username: "dan",
  email: "dan@example.com",
  password: "password",
  password_confirmation: "password"
})
