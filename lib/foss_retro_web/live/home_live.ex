defmodule FossRetroWeb.HomeLive do
  @moduledoc """
  HomeLive is FossRetro landing page.
  """
  use FossRetroWeb, :live_view
  alias FossRetroWeb.Shared

  alias FossRetro.Core.Board

  def mount(_params, _session, socket) do
    title = "Welcome to FossRetro!"
    subtitle = "Enter the title of your new retro board below..."

    {:ok, assign(socket, title: title, subtitle: subtitle, board_name: "")}
  end

  def handle_event("create_board", %{"board" => %{"title" => title}}, socket) do
    new_board = FossRetro.build_board(title)

    {:noreply, push_redirect(socket, to: board_path(new_board))}
  end

  defp board_path(%Board{key: key}), do: "/board/#{key}"
end
