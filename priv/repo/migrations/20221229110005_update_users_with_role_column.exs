defmodule Era.Repo.Migrations.UpdateUsersWithRoleColumn do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string
    end
  end

  @spec changeset_role(Ecto.Schema.t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role])
    |> Ecto.Changeset.validate_inclusion(:role, ~w(user admin))
  end
end
