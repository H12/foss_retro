defmodule CardComponent do
  use EasyRetroWeb, :live_component

  def render(assigns) do
    ~L"""
    <div phx-hook="Card" class="card">
      <div class="icons icons-top">
        <i phx-click="remove_card" phx-target="<%= @myself %>" class="lni lni-close"></i>
      </div>
      <div class="content">
        <span><%= @card.content %></span>
      </div>
      <div class="icons icons-bottom">
        <i class="comments-toggle lni <%= comment_icon(@card.comments) %>"></i>
      </div>
      <div class="comments-container hidden">
      <form class="add-comment" phx-submit="add_comment" phx-target="<%= CommentsComponent.dom_id(@id) %>">
          <input type="text" name="comment" placeholder="Add a comment">
        </form>
        <%= live_component(@socket, CommentsComponent, id: @id, board: @board, comments: @card.comments) %>
      </div>
    </div>
    """
  end

  def handle_event("remove_card", _value, socket) do
    %{id: card_id, board: board, category_id: category_id} = socket.assigns
    {:noreply, assign(socket, board: EasyRetro.remove_card(board, category_id, card_id))}
  end

  defp comment_icon([]), do: "lni-bubble"
  defp comment_icon(_), do: "lni-comments-alt"
end
