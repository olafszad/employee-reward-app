defmodule Era.Repo.Migrations.AddUpdatedTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add :amount, :integer
      add :from_user, :integer
      add :to_user, :integer
    end
  end
end

