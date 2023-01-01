defmodule EraWeb.AdminController do
    use EraWeb, :controller

    alias Era.Admin
    alias Era.Rewards
    alias Era.Transfers
    alias Era.Users.User

    def index(conn, _params) do
        rewards = Era.Repo.all(Admin)
        users = Era.Repo.all(User)
        render conn, "panel.html", rewards: rewards, users: users
    end

    def new(conn, _params) do
        changeset = Admin.changeset(%Admin{}, %{})
        render conn, "new.html", changeset: changeset
    end

    def reports(conn, _params) do
        rewards = Era.Repo.all(Rewards)
        transfers = Era.Repo.all(Transfers)
        IO.inspect(transfers)
        render conn, "reports.html", rewards: rewards, transfers: transfers
    end

    def create(conn, %{"admin" => admin}) do

        changeset = Admin.changeset(%Admin{}, admin)

        case Era.Repo.insert(changeset) do
        {:ok, _admin} ->
            conn
            |> put_flash(:info, "Reward Added")
            |> redirect(to: Routes.admin_path(conn, :index))
        {:error, changeset} ->
            render conn, "new.html", changeset: changeset
        end
    end

    def edit(conn, %{"id" => reward_id}) do
        reward = Era.Repo.get(Admin, reward_id)
        changeset = Admin.changeset(reward)
        render conn, "edit.html", changeset: changeset, reward: reward
    end

    def update(conn,  %{"id" => reward_id, "admin" => admin}) do
        old_reward = Era.Repo.get(Admin, reward_id)
        changeset = Admin.changeset(old_reward, admin)

        case Era.Repo.update(changeset) do
            {:ok, _admin} ->
                conn
                |> put_flash(:info, "Reward Updated")
                |> redirect(to: Routes.admin_path(conn, :index))
            {:error, changeset} ->
                render conn, "edit.html", changeset: changeset, reward: old_reward
        end
    end

    def delete(conn, %{"id" => reward_id}) do
        Era.Repo.get!(Admin, reward_id)
        |> Era.Repo.delete!

        conn
        |> put_flash(:info, "Reward deleted")
        |> redirect(to: Routes.admin_path(conn, :index))
    end

    def edit_user_points(conn, %{"id" => user_id}) do
        user = Era.Repo.get(User, user_id)
        changeset = User.changeset_user(user)
        render conn, "edit_user.html", changeset: changeset, user: user
    end

    def update_user_points(conn, %{"id" => user_id, "user" => user}) do
        old_number_of_points = Era.Repo.get(User, user_id)
        changeset = User.changeset_user(old_number_of_points, user)

        case Era.Repo.update(changeset) do
            {:ok, _user} ->
                conn
                |> put_flash(:info, "Points Updated")
                |> redirect(to: Routes.admin_path(conn, :index))
            {:error, changeset} ->
                render conn, "edit_user.html", changeset: changeset, user: old_number_of_points
        end
    end
end
