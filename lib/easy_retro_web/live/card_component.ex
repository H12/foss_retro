defmodule CardComponent do
  use EasyRetroWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="card-<%= @id %>" class="card">
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
    %{id: card_id, board: board, category_id: category_id} = socket.assigns
    {:noreply, assign(socket, board: EasyRetro.remove_card(board, category_id, card_id))}
  end
end
