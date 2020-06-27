defmodule EasyRetro.Boundary.BoardSession do
  alias EasyRetro.Core.Board
  use GenServer

  def child_spec(board) do
    %{
      id: {__MODULE__, {board.title, board.key}},
      start: {__MODULE__, :start_link, [board]}
    }
  end

  @impl GenServer
  def init(board) do
    {:ok, board}
  end

  def start_link(board) do
    GenServer.start_link(
      __MODULE__,
      board,
      name: via({board.title, board.key})
    )
  end

  def via({_board_title, _board_key} = registry_name) do
    {
      :via,
      Registry,
      {EasyRetro.Registry.BoardSession, registry_name}
    }
  end

  def start_retro(board) do
    DynamicSupervisor.start_child(
      EasyRetro.Supervisor.BoardSession,
      {__MODULE__, board}
    )
  end

  @impl GenServer
  def handle_call({:add_card, category_key, content}, _from, board) do
    new_board = Board.add_card(board, category_key, content)
    {:reply, new_board, new_board}
  end

  @impl GenServer
  def handle_call({:add_comment, card_id, comment}, _from, board) do
    new_board = Board.add_comment(board, card_id, comment)
    {:reply, new_board, new_board}
  end

  @impl GenServer
  def handle_call({:remove_card, category_key, card_index}, _from, board) do
    new_board = Board.remove_card(board, category_key, card_index)
    {:reply, new_board, new_board}
  end

  @impl GenServer
  def handle_call({:add_category, name}, _from, board) do
    new_board = Board.add_category(board, name)
    {:reply, new_board, new_board}
  end

  @impl GenServer
  def handle_call({:view_board}, _from, board) do
    {:reply, board, board}
  end

  def add_card(registry_name, category_key, content) do
    GenServer.call(via(registry_name), {:add_card, category_key, content})
  end

  def add_comment(registry_name, card_id, comment) do
    GenServer.call(via(registry_name), {:add_comment, card_id, comment})
  end

  def remove_card(registry_name, category_key, card_index) do
    GenServer.call(via(registry_name), {:remove_card, category_key, card_index})
  end

  def add_category(registry_name, name) do
    GenServer.call(via(registry_name), {:add_category, name})
  end

  def view_board(registry_name) do
    GenServer.call(via(registry_name), {:view_board})
  end

  def active_sessions() do
    EasyRetro.Supervisor.BoardSession
    |> DynamicSupervisor.which_children()
    |> Enum.filter(&child_pid?/1)
    |> Enum.flat_map(&active_sessions/1)
  end

  defp child_pid?({:undefined, pid, :worker, [__MODULE__]}) when is_pid(pid), do: true
  defp child_pid?(_child), do: false

  defp active_sessions({:undefined, pid, :worker, [__MODULE__]}) do
    EasyRetro.Registry.BoardSession
    |> Registry.keys(pid)
  end
end
