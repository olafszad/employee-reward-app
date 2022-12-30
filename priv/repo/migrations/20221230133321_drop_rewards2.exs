defmodule Era.Repo.Migrations.DropRewards2 do
  use Ecto.Migration

  def change do
    drop table("rewards")
  end
end
