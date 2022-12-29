defmodule EraWeb.AdminController do
    use EraWeb, :controller

    def index(conn, _params) do
        render(conn, "panel.html")
    end
end