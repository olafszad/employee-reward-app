defmodule Era.Repo.Migrations.AddRewards do
  use Ecto.Migration

  def change do
    create table(:rewards) do
    add :name, :string
    add :price, :integer

    timestamps()
    end
  end
end
