defmodule Era.Rewards do
    use Ecto.Schema
    
    import Ecto.Changeset
    
    schema "bought_rewards" do
        field :name, :string
        field :user_email, :string

        timestamps()
    end
  
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:name, :user_email])
      |> validate_required([:name, :user_email])
    end
  end
  