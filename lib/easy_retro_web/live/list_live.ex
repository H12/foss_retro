defmodule EasyRetroWeb.ListLive do
  use EasyRetroWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    EasyRetro.subscribe()
    {:ok, assign(socket, boards: EasyRetro.list_boards())}
  end

  @impl true
  def handle_info({EasyRetro, [:board, :built], _board}, socket) do
    {:noreply, assign(socket, boards: EasyRetro.list_boards())}
  end
end
