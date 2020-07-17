defmodule EasyRetroWeb.BoardView do
  use EasyRetroWeb, :view

  def render("index.html", assigns) do
    ~E"""
    <section class="hero">
      <h1>Welcome to EasyRetro!</h1>
      <p><i>Easy retrospectives for agile development</i></p>
      <div class="main-container">
    <%= link "Start a Retro", to: Routes.board_path(@conn, :new), class: "button" %>
        <%= link "Find a Retro", to: Routes.board_path(@conn, :find), class: "button button-outline" %>
      </div>
    </section>
    """
  end

  def render("new.html", assigns) do
    ~E"""
    <section class="hero">
      <h1>Start that Retro!</h1>
      <%= form_for @conn, Routes.board_path(@conn, :create), fn f -> %>
        <%= text_input f, :title %>
        <%= submit "Create Retro!" %>
      <% end %>
    </section>
    """
  end

  def render("find.html", assigns) do
    ~E"""
    <section class="hero">
      <h1>Let's retro!</h1>
      <%= form_for @conn, Routes.board_path(@conn, :join), fn f -> %>
        <%= text_input f, :key %>
        <%= submit "Join Retro!" %>
      <% end %>
    </section>
    """
  end
end
