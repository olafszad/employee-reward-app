defmodule EraWeb.AdminController do
    use EraWeb, :controller

    alias Era.Admin

    def index(conn, _params) do
        render(conn, "panel.html")
    end

    def new(conn, _params) do
        changeset = Admin.changeset(%Admin{}, %{})
        render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"admin" => admin}) do

        changeset = Admin.changeset(%Admin{}, admin)

        case Era.Repo.insert(changeset) do
        {:ok, _admin} ->
            conn
            |> put_flash(:info, "Reward Added")
            |> redirect(to: Routes.admin_path(conn, :index))
        {:error, changeset} ->
            render conn, "panel.html", changeset: changeset
        end
    end
end