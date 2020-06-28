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
        <i phx-click="toggle_comments" phx-target="<%= @myself %>" class="lni <%= comment_icon(@card.comments) %>"></i>
      </div>
      <div class="comments <%= maybe_hide(@is_hidden) %>">
        <form class="add-comment" phx-submit="add_comment" phx-target="<%= @myself %>">
          <input type="text" name="comment" placeholder="Add a comment">
        </form>
        <%= for comment <- @card.comments do %>
          <p class="comment"><%= comment %></p>
        <% end %>
      </div>
    </div>
    """
  end

  def update(%{card: card, new_update: true}, socket) do
    {:ok, assign(socket, card: card)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("add_comment", %{"comment" => comment}, socket) do
    %{board: board, id: card_id} = socket.assigns
    {:noreply, assign(socket, board: EasyRetro.add_comment(board, card_id, comment))}
  end

  def handle_event("remove_card", _value, socket) do
    %{id: card_id, board: board, category_id: category_id} = socket.assigns
    {:noreply, assign(socket, board: EasyRetro.remove_card(board, category_id, card_id))}
  end

  def handle_event("toggle_comments", _value, socket) do
    {:noreply, assign(socket, is_hidden: !socket.assigns.is_hidden)}
  end

  defp comment_icon([]), do: "lni-bubble"
  defp comment_icon(_), do: "lni-comments-alt"

  defp maybe_hide(true), do: "hidden"
  defp maybe_hide(false), do: ""
end
