defmodule Era.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    field :number_of_points, :integer, default: 0
    field :role, :string, default: "user"

    pow_user_fields()

    timestamps()
  end

  @spec changeset_role(Ecto.Schema.t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role])
    |> Ecto.Changeset.validate_inclusion(:role, ~w(user admin))
  end
end
