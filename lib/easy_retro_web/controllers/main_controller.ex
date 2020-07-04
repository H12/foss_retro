defmodule EasyRetroWeb.MainController do
  use EasyRetroWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
