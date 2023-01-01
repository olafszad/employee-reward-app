defmodule EraWeb.UserController do
    use EraWeb, :controller

    alias Era.Users.User
    alias Era.Admin
    alias Era.Rewards
    alias Era.Transfers
    alias Era.Repo

    plug :check_user_id when action in [:transfer, :edit]

    def index(conn, _params) do
        rewards = Era.Repo.all(Admin)
        transfers = Era.Repo.all(Transfers)
        user = Era.Repo.all(User)
        render conn, "profile.html", user: user, rewards: rewards, transfers: transfers
    end

    def edit(conn, %{"id" => user_id}) do
        user = Era.Repo.get(User, user_id)
        changeset = User.changeset(user)
        render conn, "transfer.html", changeset: changeset, user: user
    end

    def buy_reward(conn, %{"id" => reward_id}) do
        reward_price = Era.Repo.get(Admin, reward_id).price
        loggeed_user_points = Era.Repo.get(User, conn.assigns.current_user.id).number_of_points
        reward_map = %{"name" => Era.Repo.get(Admin, reward_id).name, "user_email" => Era.Repo.get(User, conn.assigns.current_user.id).email}
        changeset_reward = Rewards.changeset(%Rewards{}, reward_map)

        deducted_points = loggeed_user_points - reward_price
        deducted_points_map = %{"number_of_points" => deducted_points}
        changeset_deduct = User.changeset(Era.Repo.get(User, conn.assigns.current_user.id), deducted_points_map)

        if reward_price > loggeed_user_points do
            conn
            |> put_flash(:info, "Insufficient points.")
            |> redirect(to: Routes.user_path(conn, :index))
        else
            case Era.Repo.insert(changeset_reward) do
                {:ok, _transfers} ->
                    conn
                    |> put_flash(:info, "Reward bought! You will recieve email shortly.")
                    |> redirect(to: Routes.user_path(conn, :index))
                {:error, changeset} ->
                    render conn, "profile.html", changeset: changeset
            end

            case Era.Repo.update(changeset_deduct) do
                {:ok, _user} ->
                    conn
                    |> put_flash(:info, "Points Transfered")
                    |> redirect(to: Routes.user_path(conn, :index))
                {:error, changeset} ->
                    render conn, "transfer.html", changeset: changeset
            end
        end
    end

    def transfer(conn,  %{"id" => user_id, "user" => user}) do

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
        transfer_points_map = %{"amount" => points_to_deduct}
        users_map = %{"from_user" => points.email, "to_user" => reciever.email, "amount" => points_to_deduct}
        changeset_transfers = Transfers.changeset(%Transfers{}, users_map)


        if points_to_deduct > loggeed_user_points || points_to_deduct  <= 0 || conn.assigns.current_user.email == reciever.email  do
            conn
            |> put_flash(:info, "Invalid points amount or user email")
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

    def check_user_id(conn, _params) do
        %{params: %{"id" => user_id}} = conn
    
        if Era.Repo.get(User, user_id).id == conn.assigns.current_user.id do
          conn
        else
          conn
          |> put_flash(:error, "You cannot edit that")
          |> redirect(to: Routes.user_path(conn, :index))
          |> halt()
        end
    end
end