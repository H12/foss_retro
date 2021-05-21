defmodule FossRetro.Boundary.BoardSession do
  @moduledoc """
  BoardSession is an OTP GenServer that is started via a DynamicSupervisor.

  This module contains the logic for updating the internal state of each
  BoardSession process in response to different messages.
  """
  alias FossRetro.Core.Board
  alias FossRetro.Boundary.BoardManager
  use GenServer

  def child_spec(board) do
    %{
      id: {__MODULE__, registry_name_for_board(board)},
      start: {__MODULE__, :start_link, [board]},
      restart: :transient
    }
  end

  @impl GenServer
  def init(board) do
    {:ok, board, about_a_week()}
  end

  defp about_a_week, do: 600_000_000

  def start_link(board) do
    GenServer.start_link(
      __MODULE__,
      board,
      name: via(registry_name_for_board(board))
    )
  end

  def via({_board_title, _board_key} = registry_name) do
    {
      :via,
      Registry,
      {FossRetro.Registry.BoardSession, registry_name}
    }
  end

  def start_retro(board) do
    DynamicSupervisor.start_child(
      FossRetro.Supervisor.BoardSession,
      {__MODULE__, board}
    )
  end

  @impl GenServer
  def handle_info(:timeout, board) do
    BoardManager.remove_board(board)
    {:stop, :normal, board}
  end

  @impl GenServer
  def handle_call({:add_card, category_key, content, creator_id}, _from, board) do
    new_board = Board.add_card(board, category_key, content, creator_id)
    {:reply, new_board, new_board, about_a_week()}
  end

  @impl GenServer
  def handle_call({:remove_card, category_key, card_index}, _from, board) do
    new_board = Board.remove_card(board, category_key, card_index)
    {:reply, new_board, new_board, about_a_week()}
  end

  @impl GenServer
  def handle_call({:add_category, name}, _from, board) do
    new_board = Board.add_category(board, name)
    {:reply, new_board, new_board, about_a_week()}
  end

  @impl GenServer
  def handle_call({:add_voter, voter_id}, _from, board) do
    new_board = Board.add_voter(board, voter_id)
    {:reply, new_board, new_board, about_a_week()}
  end

  @impl GenServer
  def handle_call({:add_vote, voter_id, card_id}, _from, board) do
    new_board = Board.add_vote(board, voter_id, card_id)
    {:reply, new_board, new_board, about_a_week()}
  end

  @impl GenServer
  def handle_call({:remove_vote, voter_id, card_id}, _from, board) do
    new_board = Board.remove_vote(board, voter_id, card_id)
    {:reply, new_board, new_board, about_a_week()}
  end

  @impl GenServer
  def handle_call({:view_board}, _from, board) do
    {:reply, board, board, about_a_week()}
  end

  def add_card(board, category_key, content, creator_id) do
    GenServer.call(
      via(registry_name_for_board(board)),
      {:add_card, category_key, content, creator_id}
    )
  end

  def remove_card(board, category_key, card_index) do
    GenServer.call(via(registry_name_for_board(board)), {:remove_card, category_key, card_index})
  end

  def add_category(board, name) do
    GenServer.call(via(registry_name_for_board(board)), {:add_category, name})
  end

  def add_voter(board, voter_id) do
    GenServer.call(via(registry_name_for_board(board)), {:add_voter, voter_id})
  end

  def add_vote(board, voter_id, card_id) do
    GenServer.call(via(registry_name_for_board(board)), {:add_vote, voter_id, card_id})
  end

  def remove_vote(board, voter_id, card_id) do
    GenServer.call(via(registry_name_for_board(board)), {:remove_vote, voter_id, card_id})
  end

  def view_board(board) do
    GenServer.call(via(registry_name_for_board(board)), {:view_board})
  end

  def registry_name_for_board(board), do: {board.title, board.key}

  def active_sessions() do
    FossRetro.Supervisor.BoardSession
    |> DynamicSupervisor.which_children()
    |> Enum.filter(&child_pid?/1)
    |> Enum.flat_map(&active_sessions/1)
  end

  defp child_pid?({:undefined, pid, :worker, [__MODULE__]}) when is_pid(pid), do: true
  defp child_pid?(_child), do: false

  defp active_sessions({:undefined, pid, :worker, [__MODULE__]}) do
    FossRetro.Registry.BoardSession
    |> Registry.keys(pid)
  end
end
