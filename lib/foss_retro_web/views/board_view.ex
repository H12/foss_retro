defmodule FossRetroWeb.BoardView do
  use FossRetroWeb, :view

  def render("index.html", assigns) do
    ~H"""
    <section class="hero">
      <h1>Welcome to FossRetro!</h1>
      <p><i>Easy retrospectives for agile development</i></p>
      <div class="main-container">
        <%= link("Start a Retro", to: Routes.board_path(@conn, :start), class: "button") %>
        <%= link("Join a Retro", to: Routes.board_path(@conn, :join), class: "button button-outline") %>
      </div>
    </section>
    """
  end

  def render("start.html", assigns) do
    ~H"""
    <section class="hero">
      <h1>Start that Retro!</h1>
      <%= form_for @conn, Routes.board_path(@conn, :start), fn f -> %>
        <%= text_input(f, :title) %>
        <%= submit("Create Retro!") %>
      <% end %>
    </section>
    """
  end

  def render("join.html", assigns) do
    ~H"""
    <section class="hero">
      <h1>Let's retro!</h1>
      <%= form_for @conn, Routes.board_path(@conn, :join), fn f -> %>
        <%= text_input(f, :key) %>
        <%= submit("Join Retro!") %>
      <% end %>
    </section>
    """
  end
end
