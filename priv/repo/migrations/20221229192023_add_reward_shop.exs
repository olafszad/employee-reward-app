defmodule Era.Repo.Migrations.AddRewardShop do
  use Ecto.Migration

  def change do
    create table(:reward_shop) do
    add :name, :string
    add :price, :integer

    timestamps()
    end
  end
end
