defmodule Era.Task do

    alias Era.Users.User

    def work do
        Era.Repo.update_all(User, set: [number_of_points: 50])
    end
  end