defmodule Era.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
      create table(:users) do
      add :email, :string
      add :password, :string
      add :role_id, :string
      add :number_of_points, :string

      timestamps()
    end
  end
end
