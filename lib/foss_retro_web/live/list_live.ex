defmodule FossRetroWeb.ListLive do
  @moduledoc """
  ListLive handles the view logic for rendering a real-time list of in-use Boards.
  """
  use FossRetroWeb, :live_view

  def mount(_params, _session, socket) do
    FossRetro.subscribe()
    {:ok, assign(socket, boards: FossRetro.list_boards())}
  end

  def handle_info({FossRetro, [:board, :built], _board}, socket) do
    {:noreply, assign(socket, boards: FossRetro.list_boards())}
  end

  def handle_info({FossRetro, [:board, :updated], _board}, socket) do
    {:noreply, assign(socket, boards: FossRetro.list_boards())}
  end
end
