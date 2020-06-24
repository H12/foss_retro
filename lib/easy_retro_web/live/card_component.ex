defmodule CardComponent do
  use EasyRetroWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="card"><span class="content"><%= @content %></span></div>
    """
  end
end
