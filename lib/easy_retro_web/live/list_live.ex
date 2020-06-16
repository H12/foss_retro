defmodule EasyRetroWeb.ListLive do
  use EasyRetroWeb, :live_view

  def mount(_params, _session, socket) do
    EasyRetro.subscribe()
    {:ok, assign(socket, boards: EasyRetro.list_boards())}
  end

  def handle_info({EasyRetro, [:board, :built], _board}, socket) do
    {:noreply, assign(socket, boards: EasyRetro.list_boards())}
  end

  def handle_info({EasyRetro, [:board, :updated], _board}, socket) do
    {:noreply, assign(socket, boards: EasyRetro.list_boards())}
  end
end
