defmodule FossRetroWeb.ListLive do
  @moduledoc """
  ListLive handles the view logic for rendering a real-time list of in-use Boards.
  """
  use FossRetroWeb, :live_view

  def render(assigns) do
    ~L"""
    <section class="hero">
      <h1>Wow, look at all them retro boards!</h1>
        <table>
          <tr>
            <th>ID Key</th>
            <th>Board Title</th>
            <th>Card Count</th>
          </tr>
          <%= for {key, board} <- @boards do %>
            <tr>
              <td><%= key %></td>
              <td><%= board.title %></td>
              <td><%= map_size(board.cards) %></td>
            </tr>
          <% end %>
      </table>
    </section>
    """
  end

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
