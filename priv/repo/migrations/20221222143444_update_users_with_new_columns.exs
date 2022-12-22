defmodule Era.Repo.Migrations.UpdateUsersWithNewColumns do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role_id, :integer
      add :number_of_points, :integer
    end
  end
end
