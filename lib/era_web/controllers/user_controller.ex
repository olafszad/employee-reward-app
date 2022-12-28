defmodule EraWeb.UserController do
    use EraWeb, :controller

    def index(conn, _params) do
        render(conn, "profile.html")
    end
end