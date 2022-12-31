defmodule Era.Repo.Migrations.AddTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add :amount, :integer
      add :from_user, references(:users)
      add :to_user, references(:users)
    end
  end
end
