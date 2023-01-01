defmodule Era.Repo.Migrations.AddBoughtRewards do
  use Ecto.Migration

  def change do
    create table(:bought_rewards) do
    add :name, :string
    add :user_email, :string

    timestamps()
    end
  end
end
