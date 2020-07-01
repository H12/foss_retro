defmodule EasyRetro do
  @moduledoc """
  The main API for interacting with EasyRetro's OTP business logic
  """
  alias EasyRetro.Boundary.{BoardManager, BoardSession}
  alias EasyRetro.Core.Board

  @topic inspect(__MODULE__)

  def subscribe() do
    Phoenix.PubSub.subscribe(EasyRetro.PubSub, @topic)
  end

  def build_board(title) do
    title
    |> BoardManager.build_board()
    |> start_retro
    |> notify_subscribers([:board, :built])
  end

  def list_boards do
    BoardManager.list_boards()
  end

  def lookup_board_by_key(key) do
    BoardManager.lookup_board_by_key(key)
  end

  def add_card(board, category_key, card_content) do
    board
    |> registry_name_for_board()
    |> BoardSession.add_card(category_key, card_content)
    |> BoardManager.update_board()
    |> notify_subscribers([:board, :updated])
  end

  def remove_card(board, category_key, card_index) do
    board
    |> registry_name_for_board()
    |> BoardSession.remove_card(category_key, card_index)
    |> BoardManager.update_board()
    |> notify_subscribers([:board, :updated])
  end

  def add_comment(board, card_id, comment) do
    board
    |> registry_name_for_board()
    |> BoardSession.add_comment(card_id, comment)
    |> BoardManager.update_board()
    |> notify_subscribers([card_id, :comment, :added])
  end

  def add_category(board, category_name) do
    board
    |> registry_name_for_board()
    |> BoardSession.add_category(category_name)
    |> BoardManager.update_board()
    |> notify_subscribers([:board, :updated])
  end

  defp start_retro(board) do
    with {:ok, _} <- BoardSession.start_retro(board) do
      registry_name_for_board(board)
    else
      error -> error
    end
  end

  defp notify_subscribers({:ok, board_key, card_id}, event) do
    board = lookup_board_by_key(board_key)
    card = board.cards[card_id]
    Phoenix.PubSub.broadcast(EasyRetro.PubSub, @topic, {__MODULE__, event, card})
    board
  end

  defp notify_subscribers({:ok, key}, event) do
    board = lookup_board_by_key(key)
    Phoenix.PubSub.broadcast(EasyRetro.PubSub, @topic, {__MODULE__, event, board})
    board
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}

  defp notify_subscribers(%Board{key: key}, [card_id | event]) when is_integer(card_id) do
    notify_subscribers({:ok, key, card_id}, event)
  end

  defp notify_subscribers(%Board{key: key}, event), do: notify_subscribers({:ok, key}, event)

  defp notify_subscribers({_title, key}, event), do: notify_subscribers({:ok, key}, event)

  defp registry_name_for_board(board) do
    registry_name = {board.title, board.key}

    with {:via, _, _} = _ <- BoardSession.via(registry_name) do
      registry_name
    else
      _error -> {:error, "registry_name is invalid"}
    end
  end
end
