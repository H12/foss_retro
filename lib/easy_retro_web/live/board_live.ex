defmodule EasyRetroWeb.BoardLive do
  use EasyRetroWeb, :live_view

  def mount(%{"key" => key}, _session, socket) do
    EasyRetro.subscribe()
    {:ok, assign(socket, board: EasyRetro.lookup_board_by_key(key))}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, board: nil)}
  end

  def handle_params(%{"key" => key}, _uri, socket) do
    board = EasyRetro.lookup_board_by_key(key)
    {:noreply, assign(socket, board: board)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, board: nil)}
  end

  def handle_info({EasyRetro, [:board, :built], _board}, socket) do
    {:noreply, socket}
  end

  def handle_info({EasyRetro, [:board, :updated], board}, socket) do
    {:noreply, maybe_assign_board(socket, board)}
  end

  def handle_event("join", %{"key" => key}, socket) do
    {:noreply, push_patch(socket, to: Routes.live_path(socket, __MODULE__, key))}
  end

  def handle_event("add_category", %{"name" => name}, socket) do
    board = socket.assigns.board
    {:noreply, assign(socket, board: EasyRetro.add_category(board, name))}
  end

  def handle_event("add_card", %{"category" => category_id, "content" => content}, socket) do
    board = socket.assigns.board
    new_board = EasyRetro.add_card(board, String.to_integer(category_id), content)
    IO.puts("CARD ADDED BOARD")
    IO.inspect new_board
    {:noreply, assign(socket, board: new_board)}
  end

  defp maybe_assign_board(socket, board) do
    if board.key == socket.assigns.board.key do
      assign(socket, board: board)
    else
      socket
    end
  end
end

