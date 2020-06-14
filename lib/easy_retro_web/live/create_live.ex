defmodule EasyRetroWeb.CreateLive do
  use EasyRetroWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, key: nil, title: "")}
  end

  @impl true
  def handle_event("create", %{"title" => title}, socket) do
    %EasyRetro.Core.Board{key: key} = EasyRetro.build_board(title)

    {:noreply, assign(socket, key: key, title: title)}
  end
end
