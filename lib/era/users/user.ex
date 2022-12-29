defmodule Era.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :number_of_points, :integer, default: 0

    pow_user_fields()

    timestamps()
  end
end
