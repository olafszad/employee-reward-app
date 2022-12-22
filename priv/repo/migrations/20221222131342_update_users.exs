defmodule Era.Repo.Migrations.UpdateUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :role_id, :integer
      modify :number_of_points, :integer
    end
  end
end
