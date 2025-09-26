defmodule GothamScheduler.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :username, :string
      add :email, :string
      add :password, :string

      timestamps(type: :utc_datetime)
    end

    # Ensure each email is unique across all users
    create unique_index(:users, [:email])
  end
end
