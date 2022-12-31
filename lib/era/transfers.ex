defmodule Era.Transfers do
    use Ecto.Schema

    import Ecto.Changeset

    schema "transfers" do
        field :amount, :integer
        belongs_to :from_user, Discuss.Users.User
        belongs_to :to_user, Discuss.Users.User
    end
end