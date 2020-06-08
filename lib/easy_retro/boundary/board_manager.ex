defmodule EasyRetro.Boundary.BoardManager do
  alias EasyRetro.Core.Board
  use GenServer

  def init(boards) when is_map(boards) do
    {:ok, boards}
  end

  def init(_boards), do: {:error, "boards must be a map"}

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options)
  end

  def handle_call({:build_board, title}, _from, boards) do
    board = Board.new(title)
    new_boards = Map.put(boards, board.key, board)

    {:reply, board.key, new_boards}
  end

  def handle_call({:lookup_board_by_key, key}, _from, boards) do
    {:reply, boards[key], boards}
  end

  def handle_call({:remove_board, key}, _from, boards) do
    {:reply, :ok, Map.delete(boards, key)}
  end

  def build_board(manager \\ __MODULE__, title) do
    GenServer.call(manager, {:build_board, title})
  end

  def lookup_board_by_key(manager \\ __MODULE__, key) do
    GenServer.call(manager, {:lookup_board_by_key, key})
  end

  def remove_board(manager \\ __MODULE__, key) do
    GenServer.call(manager, {:remove_board, key})
  end
end
