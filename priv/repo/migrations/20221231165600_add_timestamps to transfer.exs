defmodule :"Elixir.Era.Repo.Migrations.AddTimestamps to transfer" do
  use Ecto.Migration

  def change do
    alter table(:transfers) do

      timestamps()
    end
  end
end
