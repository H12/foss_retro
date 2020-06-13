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
end

