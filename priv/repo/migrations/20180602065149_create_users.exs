defmodule Jeeves.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext")

    create table(:users) do
      add(:username, :citext)
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:is_registered, :boolean, default: false, null: false)
      add(:is_administrator, :boolean, default: false, null: false)

      timestamps()
    end

    create(unique_index(:users, [:username]))
    create(unique_index(:users, [:email]))
  end
end
