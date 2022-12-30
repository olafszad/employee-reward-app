defmodule Era.Repo.Migrations.DropRewardShop do
  use Ecto.Migration

  def change do
    drop table("reward_shop")
  end
end
