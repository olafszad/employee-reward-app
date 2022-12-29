defmodule EraWeb.UserController do
    use EraWeb, :controller

    def index(conn, _params) do
        render(conn, "profile.html")
    end

    def transfer(conn) do
        
    end
end