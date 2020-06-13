defmodule EasyRetroWeb.ListLive do
  use EasyRetroWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    EasyRetro.subscribe()
    {:ok, assign(socket, boards: EasyRetro.list_boards())}
  end

  @impl true
  def handle_info({EasyRetro, [:board, :built], _code}, socket) do
    {:noreply, fetch_boards(socket)}
  end

  defp fetch_boards(socket) do
    assign(socket, boards: EasyRetro.list_boards())
  end
end
