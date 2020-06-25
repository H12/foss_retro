defmodule CardComponent do
  use EasyRetroWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="card">
      <div class="icons icons-top">
        <i phx-click="remove_card" phx-target="<%= @myself %>" class="lni lni-close"></i>
      </div>
      <div class="content">
        <span><%= @card.content %></span>
      </div>
      <div class="icons icons-bottom">
        <i class="lni lni-bubble"></i>
      </div>
    </div>
    """
  end

  def handle_event("remove_card", _value, socket) do
    %{board: board, category_key: category_key, index: index} = socket.assigns
    new_board = EasyRetro.remove_card(board, category_key, index)

    {:noreply, assign(socket, board: new_board)}
  end
end
