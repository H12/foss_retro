defmodule EasyRetroWeb.BoardController do
  use EasyRetroWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def start(%{method: "GET"} = conn, _params) do
    render(conn, "start.html", changeset: :title)
  end

  def start(%{method: "POST"} = conn, %{"title" => title}) do
    %{key: key} = EasyRetro.build_board(title)
    redirect(conn, to: "/board/" <> key)
  end

  def join(%{method: "GET"} = conn, _params) do
    render(conn, "join.html")
  end

  def join(%{method: "POST"} = conn, %{"key" => key}) do
    with %{key: key} <- EasyRetro.lookup_board_by_key(key) do
      redirect(conn, to: "/board/" <> key)
    else
      _ ->
        conn
        |> put_flash(:error, "No board exists with the key '#{key}'")
        |> render("join.html")
    end
  end

  def board_live(conn, %{"key" => key}) do
    Phoenix.LiveView.Controller.live_render(conn, EasyRetroWeb.BoardLive,
      id: "board-live",
      session: %{"key" => key}
    )
  end
end
