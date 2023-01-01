defmodule Era.Repo.Migrations.AddTimestampsToTransfers do
  use Ecto.Migration

  def change do
    alter table(:transfers) do

      timestamps()
    end
  end
end
