defmodule FossRetroWeb.CardComponent do
  @moduledoc """
  CardComponent contains both the markup and view logic for the FossRetro
  "Cards" (the things meant to represent sticky-notes on a physical retro
  board). This module handles user interractions with a specific card, and
  dispatches appropriate events to the FossRetro module.

  ## Instance Variables
  - id: The unique identifier of the CardComponent
  - card: The Card struct containing the CardComponent's data
  - board: The Board struct containing the card
  - current_user: The unique identifier of the current session user
  """
  use FossRetroWeb, :live_component

  def handle_event("add_vote", _value, socket) do
    %{id: card_id, board: board, current_user: current_user} = socket.assigns
    {:noreply, assign(socket, board: FossRetro.add_vote(board, current_user, card_id))}
  end

  def handle_event("remove_vote", _value, socket) do
    %{id: card_id, board: board, current_user: current_user} = socket.assigns
    {:noreply, assign(socket, board: FossRetro.remove_vote(board, current_user, card_id))}
  end

  def handle_event("remove_card", _value, socket) do
    %{id: card_id, board: board, category_id: category_id} = socket.assigns
    {:noreply, assign(socket, board: FossRetro.remove_card(board, category_id, card_id))}
  end

  defp click_event(board, current_user, card_id) do
    if has_voted(board, current_user, card_id) do
      "remove_vote"
    else
      "add_vote"
    end
  end

  defp icon_status(board, current_user, card_id) do
    if has_voted(board, current_user, card_id) do
      "text-purple-800"
    else
      ""
    end
  end

  defp has_voted(board, current_user, card_id),
    do: Enum.member?(board.voters[current_user], card_id)
end
