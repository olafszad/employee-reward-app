defmodule EraWeb.UserController do
    use EraWeb, :controller

    alias Era.Users.User
    alias Era.Transfers
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

    def trans(conn,  %{"id" => user_id, "user" => user}) do

    end

    # def add_points_to_selected_user(conn,  %{"id" => user_id, "user" => user}) do
    #     points = Era.Repo.get(User, user_id)
    #     loggeed_user_points = Era.Repo.get(User, conn.assigns.current_user.id).number_of_points
    #     points_to_deduct = String.to_integer(user["number_of_points"])
    #     deducted_points = loggeed_user_points - points_to_deduct
    #     deducted_points_map = %{"number_of_points" => deducted_points}
    #     changeset = User.changeset(points, deducted_points_map)

    #     IO.puts("whos calling me?")

    # end

    def deduct_points_from_logged_user(conn,  %{"id" => user_id, "user" => user}) do

        #Handling current user points to deduct
        points = Era.Repo.get(User, user_id)
        loggeed_user_points = Era.Repo.get(User, conn.assigns.current_user.id).number_of_points
        points_to_deduct = String.to_integer(user["number_of_points"])
        transfering_to_user_email = user["email"]
        deducted_points = loggeed_user_points - points_to_deduct
        deducted_points_map = %{"number_of_points" => deducted_points}
        changeset_deduct = User.changeset(points, deducted_points_map)

        #Handling reciever points to add

        reciever = Era.Repo.get_by(User, email: transfering_to_user_email)
        reciever_current_points = reciever.number_of_points
        reciever_added_points = reciever_current_points + points_to_deduct
        reciever_added_points_map = %{"number_of_points" => reciever_added_points}
        changeset_receiver = User.changeset(reciever, reciever_added_points_map)

        #Handling data to insert into transfer history
        sender_id = points.id
        receiver_id = reciever.id
        transfer_points_map = %{"amount" => points_to_deduct}
        users_map = %{"from_user" => points.id, "to_user" => reciever.id, "amount" => points_to_deduct}
        changeset_transfers = Transfers.changeset(%Transfers{}, users_map)





        IO.puts("++++++++++++++++++++++++++++++++++++")
        IO.inspect(changeset_transfers)
        IO.puts("++++++++++++++++++++++++++++++++++++")

        if points_to_deduct > loggeed_user_points || points_to_deduct <= 0 do
            conn
            |> put_flash(:info, "Invalid points amount")
            |> redirect(to: Routes.user_path(conn, :index))
        else
            case Era.Repo.insert(changeset_transfers) do
                {:ok, _transfers} ->
                    conn
                    |> put_flash(:info, "Points Transfered")
                    |> redirect(to: Routes.user_path(conn, :index))
                {:error, changeset} ->
                    render conn, "transfer.html", changeset: changeset, user: points
            end

            case Era.Repo.update(changeset_deduct) do
                {:ok, _user} ->
                    conn
                    |> put_flash(:info, "Points Transfered")
                    |> redirect(to: Routes.user_path(conn, :index))
                {:error, changeset} ->
                    render conn, "transfer.html", changeset: changeset, user: points
            end

            case Era.Repo.update(changeset_receiver) do
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