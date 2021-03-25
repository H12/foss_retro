defmodule CardComponent do
  use FossRetroWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="card-<%= @id %>" class="card">
      <div class="icons icons-top">
      <%= if @current_user == @card.creator do %>
        <i phx-click="remove_card" phx-target="<%= @myself %>" class="lni lni-close"></i>
      <% else %>
        <i class="lni lni-spacer"></i>
      <% end %>
      </div>
      <div class="content">
        <span><%= @card.content %></span>
      </div>
      <div class="icons icons-bottom">
        <span class="votes"><%= @card.votes %></span>
        <i phx-click="<%= click_event(@board, @current_user, @id) %>"
           phx-target="<%= @myself %>"
           class="lni lni-thumbs-up <%= icon_status(@board, @current_user, @id) %>"></i>
      </div>
    </div>
    """
  end

  def handle_event("add_vote", _value, socket) do
    %{id: card_id, board: board, current_user: current_user} = socket.assigns
    {:noreply, assign(socket, board: FossRetro.add_vote(board, current_user, card_id))}
  end

  def handle_event("remove_vote", _value, socket) do
    %{id: card_id, board: board, current_user: current_user} = socket.assigns
    {:noreply, assign(socket, board: FossRetro.remove_vote(board, current_user, card_id))}
  end

  def handle_event("remove_card", _value, socket) do
    %{id: card_id, board: board, category_id: category_id} = socket.assigns
    {:noreply, assign(socket, board: FossRetro.remove_card(board, category_id, card_id))}
  end

  defp click_event(board, current_user, card_id) do
    if has_voted(board, current_user, card_id) do
      "remove_vote"
    else
      "add_vote"
    end
  end

  defp icon_status(board, current_user, card_id) do
    if has_voted(board, current_user, card_id) do
      "active"
    else
      ""
    end
  end

  defp has_voted(board, current_user, card_id),
    do: Enum.member?(board.voters[current_user], card_id)
end
