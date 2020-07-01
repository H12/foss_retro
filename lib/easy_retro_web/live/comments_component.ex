defmodule CommentsComponent do
  use EasyRetroWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="comments-<%= @id %>" class="comments">
      <%= for {comment, id} <- Enum.with_index(@comments) do %>
        <p class="comment"><%= comment %></p>
      <% end %>
    </div>
    """
  end

  def handle_event("add_comment", %{"comment" => comment}, socket) do
    %{board: board, id: card_id} = socket.assigns
    EasyRetro.add_comment(board, card_id, comment)

    {:noreply, assign(socket, comments: [comment | socket.assigns.comments])}
  end

  def dom_id(id), do: "#comments-" <> to_string(id)
end
