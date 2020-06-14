defmodule EasyRetro do
  @moduledoc """
  The main API for interacting with EasyRetro's OTP business logic
  """
  alias EasyRetro.Boundary.{BoardManager, BoardSession}

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
    BoardSession.active_sessions()
  end

  def lookup_board_by_key(key) do
    key
    |> BoardManager.lookup_board_by_key()
    |> registry_name_for_board()
    |> BoardSession.view_board()
  end

  def add_card(board, category_key, card_content) do
    board
    |> registry_name_for_board()
    |> BoardSession.add_card(category_key, card_content)
  end

  def add_category(board, category_name) do
    board
    |> registry_name_for_board()
    |> BoardSession.add_category(category_name)
  end

  defp start_retro(board) do
    with {:ok, _} <- BoardSession.start_retro(board) do
      registry_name_for_board(board)
    else
      error -> error
    end
  end

  defp notify_subscribers({:ok, key}, event) do
    Phoenix.PubSub.broadcast(EasyRetro.PubSub, @topic, {__MODULE__, event, key})
    {:ok, key}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}

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
