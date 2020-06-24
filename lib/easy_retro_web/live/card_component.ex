defmodule CardComponent do
  use EasyRetroWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="card">
      <div class="icons icons-top">
        <i class="lni lni-sm lni-close"></i>
      </div>
      <div class="content">
        <span><%= @content %></span>
      </div>
      <div class="icons icons-bottom">
        <i class="lni lni-sm lni-bubble"></i>
      </div>
    </div>
    """
  end
end
