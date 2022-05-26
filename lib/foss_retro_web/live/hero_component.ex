defmodule FossRetroWeb.Shared do
  @moduledoc """
  HeroComponent is a simple liveview for Hero content sections. It generally
  only displays some text, and contains nav or input elements.

  ## Instance Variables
  - title: The title to display
  - subtitle: The subtitle to display under the title
  """
  use Phoenix.Component

  def hero(assigns) do
    ~H"""
    <section class="relative px-6 pt-10 pb-8 bg-white shadow-xl ring-1
    ring-gray-900/5 sm:max-w-lg sm:mx-auto sm:rounded-lg sm:px-10">
      <h1 class="text-center text-2xl"><%= assigns.title %></h1>
      <h2 class="text-center text-lg pt-3"><i><%= assigns.subtitle %></i></h2>
      <div class="flex width-max pt-4 space-x-5">
        <%= render_slot(@inner_block) %>
      </div>
    </section>
    """
  end
end
