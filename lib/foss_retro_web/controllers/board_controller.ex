defmodule FossRetroWeb.BoardController do
  use FossRetroWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def start(%{method: "GET"} = conn, _params) do
    render(conn, "start.html", changeset: :title)
  end

  def start(%{method: "POST"} = conn, %{"title" => title}) do
    %{key: key} = FossRetro.build_board(title)
    redirect(conn, to: "/board/" <> key)
  end

  def join(%{method: "GET"} = conn, _params) do
    render(conn, "join.html")
  end

  def join(%{method: "POST"} = conn, %{"key" => key}) do
    with %{key: key} <- FossRetro.lookup_board_by_key(key) do
      redirect(conn, to: "/board/" <> key)
    else
      _ ->
        conn
        |> put_flash(:error, "No board exists with the key '#{key}'")
        |> render("join.html")
    end
  end

  def board_live(conn, %{"key" => key}) do
    # TODO: Add ability for users to set their own name, and codify it into the token
    user_token = Phoenix.Token.sign(FossRetroWeb.Endpoint, "user token", "user name")

    conn
    |> maybe_put_session(:user_token, user_token)
    |> Phoenix.LiveView.Controller.live_render(FossRetroWeb.BoardLive,
      id: "board-live",
      session: %{"key" => key}
    )
  end

  defp maybe_put_session(conn, key, content) do
    session_content = get_session(conn, key)

    if session_content do
      conn
    else
      put_session(conn, key, content)
    end
  end
end
