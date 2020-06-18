defmodule EasyRetroWeb.MainLive do
  use EasyRetroWeb, :live_view

  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <h1>Welcome to EasyRetro!</h1>
      <p><i>Easy retrospectives for agile development</i></p>
      <div class="main-container">
        <%= live_patch "Start a Retro", to: Routes.live_path(@socket, EasyRetroWeb.CreateLive), class: "button" %>
        <%= live_patch "Join a Retro", to: Routes.live_path(@socket, EasyRetroWeb.BoardLive), class: "button" %>
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
