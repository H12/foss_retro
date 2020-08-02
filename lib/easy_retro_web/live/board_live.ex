defmodule EasyRetroWeb.BoardLive do
  use EasyRetroWeb, :live_view
  alias EasyRetro.Core.Board

  def mount(_params, %{"key" => key, "user_token" => user_token}, socket) do
    EasyRetro.subscribe()
    # TODO: Add the user_token to the board via a yet-to-be-created `add_voter` function
    {:ok, assign(socket, board: EasyRetro.lookup_board_by_key(key))}
  end

  def mount(_params, _session, socket) do
    EasyRetro.subscribe()
    {:ok, assign(socket, board: nil)}
  end

  def handle_info({EasyRetro, [:board, :built], _board}, socket) do
    {:noreply, socket}
  end

  def handle_info({EasyRetro, [:board, :updated], board}, socket) do
    {:noreply, maybe_assign_board(socket, board)}
  end

  def handle_event("add_category", %{"name" => name}, socket) do
    board = socket.assigns.board
    {:noreply, assign(socket, board: EasyRetro.add_category(board, name))}
  end

  def handle_event("add_card", %{"category" => category_id, "content" => content}, socket) do
    board = socket.assigns.board
    new_board = EasyRetro.add_card(board, String.to_integer(category_id), content)
    {:noreply, assign(socket, board: new_board)}
  end

  defp maybe_assign_board(socket, board) do
    with %Board{key: key} <- socket.assigns.board,
         true <- board.key == key do
      assign(socket, board: board)
    else
      _ -> socket
    end
  end
end
