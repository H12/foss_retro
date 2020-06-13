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
    BoardManager.build_board(title)
    |> start_retro
    |> notify_subscribers([:board, :built])
  end

  def list_boards do
    BoardManager.list_boards()
  end

  def lookup_board_by_key(key) do
    BoardManager.lookup_board_by_key(key)
  end

  def start_retro(%Board{key: key}) do
    with %Board{} = board <- EasyRetro.lookup_board_by_key(key),
         {:ok, _} <- BoardSession.start_retro(board) do
      registry_name_for_board(board)
    else
      error -> error
    end
  end

  def add_card(registry_name, card_content, category_key) do
    BoardSession.add_card(registry_name, card_content, category_key)
  end

  def add_category(registry_name, category_name) do
    BoardSession.add_category(registry_name, category_name)
  end

  defp notify_subscribers(%Board{key: key}, event) do
    notify_subscribers({:ok, key}, event)
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
