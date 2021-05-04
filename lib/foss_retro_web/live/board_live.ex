defmodule FossRetroWeb.BoardLive do
  @moduledoc """
  BoardLive contains both the view logic for the the LiveView that facilitates
  UI interraction with FossRetro Boards. This module is responsible for handling
  user interractions with a particular Board and dispatching appropriate events
  to the FossRetro module.

  See the `board_live.html.leex` file for this module's corresponding html markup.

  ## Instance Variables
  - board: The Board struct containing relevant Board data
  - current_user: The unique identifier of the current session user
  """
  use FossRetroWeb, :live_view
  alias FossRetroWeb.CardComponent

  def mount(_params, %{"key" => key, "user_token" => user_token}, socket) do
    FossRetro.subscribe()

    board =
      key
      |> FossRetro.lookup_board_by_key()
      |> FossRetro.add_voter(user_token)

    {:ok, assign(socket, board: board, current_user: user_token)}
  end

  def mount(_params, _session, socket) do
    FossRetro.subscribe()
    {:ok, assign(socket, board: nil)}
  end

  def handle_info({FossRetro, [:board, :built], _board}, socket) do
    {:noreply, socket}
  end

  def handle_info({FossRetro, [:board, :updated], board}, socket) do
    {:noreply, maybe_assign_board(socket, board)}
  end

  def handle_event("add_category", %{"name" => name}, socket) do
    board = socket.assigns.board
    {:noreply, assign(socket, board: FossRetro.add_category(board, name))}
  end

  def handle_event("add_card", %{"category" => category_id, "content" => content, "creator" => creator_id}, socket) do
    board = socket.assigns.board
    new_board = FossRetro.add_card(board, String.to_integer(category_id), content, creator_id)
    {:noreply, assign(socket, board: new_board)}
  end

  defp maybe_assign_board(socket, board) do
    with %{key: key} <- socket.assigns.board,
         true <- board.key == key do
      assign(socket, board: board)
    else
      _ -> socket
    end
  end
end
