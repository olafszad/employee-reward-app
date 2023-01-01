defmodule Era.Repo.Migrations.UpdateTransactioDropUsersids do
  use Ecto.Migration

  def change do
    drop table("transfers")
  end
end
