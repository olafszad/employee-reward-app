defmodule Era.Repo.Migrations.UpdateUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :role_id, :int
      modify :number_of_points, :int
    end
  end
end
