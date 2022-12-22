defmodule Era.User do
    use EraWeb, :module

    schema "users" do
        field :email, :string
        field :password, :string
        field :role_id, :int
        field :number_of_points, :int
    end

end