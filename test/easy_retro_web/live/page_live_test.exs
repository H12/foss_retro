defmodule EasyRetroWeb.PageLiveTest do
  use EasyRetroWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to EasyRetro!"
    assert render(page_live) =~ "Welcome to EasyRetro!"
  end
end
