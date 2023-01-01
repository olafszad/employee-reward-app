defmodule Era.Repo.Migrations.UpdateTransfers do
  use Ecto.Migration

  def change do
    alter table(:transfers) do
      remove :from_user, :integer
      remove :to_user, :integer
      add :from_user, :string
      add :to_user, :string
    end
  end
end