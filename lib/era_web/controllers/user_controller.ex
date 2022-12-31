defmodule EraWeb.UserController do
    use EraWeb, :controller

    alias Era.Users.User
    alias Era.Repo

    plug :check_user_id when action in [:transfer, :deduct_points, :edit]

    def index(conn, _params) do


        # loggeed_user_points = Era.Repo.get(User, conn.assigns.current_user.id).number_of_points
        # user = Era.Repo.get(User, conn.assigns.current_user.id)
        user = Era.Repo.all(User)

        # IO.inspect(loggeed_user_points)
        # IO.inspect(loggeed_user_id)
        # IO.inspect(loggeed_user_points)
        # IO.inspect(loggeed_user_id)


        render conn, "profile.html", user: user
    end

    def edit(conn, %{"id" => user_id}) do
        loggeed_user_id = Era.Repo.get(User, conn.assigns.current_user.id).id

        user = Era.Repo.get(User, user_id)
        changeset = User.changeset(user)
        render conn, "transfer.html", changeset: changeset, user: user
    end

    def add_points_to_selected_user(conn, %{"id" => user_id}) do

    end

    def deduct_points_from_logged_user(conn,  %{"id" => user_id, "user" => user}) do
        points = Era.Repo.get(User, user_id)
        loggeed_user_points = Era.Repo.get(User, conn.assigns.current_user.id).number_of_points
        points_to_deduct = String.to_integer(user["number_of_points"])
        deducted_points = loggeed_user_points - points_to_deduct
        deducted_points_map = %{"number_of_points" => deducted_points}

        changeset = User.changeset(points, deducted_points_map)

        if points_to_deduct > loggeed_user_points || points_to_deduct <= 0 do
            conn
            |> put_flash(:info, "Invalid points amount")
            |> redirect(to: Routes.user_path(conn, :index))
        else
            case Era.Repo.update(changeset) do
                {:ok, _user} ->
                    conn
                    |> put_flash(:info, "Points Transfered")
                    |> redirect(to: Routes.user_path(conn, :index))
                {:error, changeset} ->
                    render conn, "transfer.html", changeset: changeset, user: points
            end
        end   
    end

    def add_points() do

    end

    def transaction_history() do

    end

    def check_user_id(conn, _params) do
        %{params: %{"id" => user_id}} = conn
    
        if Era.Repo.get(User, user_id).id == conn.assigns.current_user.id do
          conn
        else
          conn
          |> put_flash(:error, "You cannot edit that")
          |> redirect(to: Routes.topic_path(conn, :index))
          |> halt()
        end
    end
end