defmodule Era.Admin do
    use Ecto.Schema
    import Ecto.Changeset
    
    schema "rewards" do
        field :name, :string
        field :price, :integer
    end
  
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:name, :price])
      |> validate_required([:name, :price])
    end
  end
  