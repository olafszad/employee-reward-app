defmodule Era.Repo.Migrations.UpdateUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :role_id, :integer
      remove :number_of_points, :integer
    end
  end
end
