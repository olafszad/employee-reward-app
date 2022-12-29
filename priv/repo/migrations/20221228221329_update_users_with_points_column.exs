defmodule Era.Repo.Migrations.UpdateUsersWithPointsColumn do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :number_of_points, :integer
    end
  end
end
