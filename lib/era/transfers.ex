defmodule Era.Transfers do
    use Ecto.Schema

    import Ecto.Changeset

    schema "transfers" do
        field :amount, :integer
        field :from_user, :string
        field :to_user, :string

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:amount, :from_user, :to_user])
        |> validate_required([:amount, :from_user, :to_user])
    end
end