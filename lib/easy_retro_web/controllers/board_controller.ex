defmodule EasyRetroWeb.BoardController do
  use EasyRetroWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html", changeset: :title)
  end

  def create(conn, %{"title" => title}) do
    %{key: key} = EasyRetro.build_board(title)
    redirect(conn, to: "/board/" <> key)
  end

  def find(conn, _params) do
    render(conn, "find.html")
  end

  def join(conn, %{"key" => key}) do
    with %{key: key} <- EasyRetro.lookup_board_by_key(key) do
      redirect(conn, to: "/board/" <> key)
    else
      _ ->
        conn
        |> put_flash(:error, "No board exists with the key '#{key}'")
        |> render("find.html")
    end
  end
end
