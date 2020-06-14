defmodule EasyRetroWeb.BoardLive do
  use EasyRetroWeb, :live_view

  def mount(%{"key" => key}, _session, socket) do
    {:ok, assign(socket, board: EasyRetro.lookup_board_by_key(key), key: key)}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, board: nil, key: nil)}
  end

  def handle_event("join", %{"key" => key}, socket) do
    {:noreply, assign(socket, board: EasyRetro.lookup_board_by_key(key), key: key)}
  end

  def handle_event("add_category", %{"name" => name}, socket) do
    board = socket.assigns.board
    {:noreply, assign(socket, board: EasyRetro.add_category(board, name))}
  end

  def handle_event("add_card", %{"category" => key, "content" => content}, socket) do
    board = socket.assigns.board
    {:noreply, assign(socket, board: EasyRetro.add_card(board, String.to_integer(key), content))}
  end
end

