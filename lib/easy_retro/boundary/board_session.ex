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
  def handle_call({:add_card, content, category_key}, _from, board) do
    new_board = Board.add_card(board, content, category_key)
    {:reply, new_board, new_board}
  end

  @impl GenServer
  def handle_call({:add_category, name}, _from, board) do
    new_board = Board.add_category(board, name)
    {:reply, new_board, new_board}
  end

  def add_card(registry_name, content, category_key) do
    GenServer.call(via(registry_name), {:add_card, content, category_key})
  end

  def add_category(registry_name, name) do
    GenServer.call(via(registry_name), {:add_category, name})
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
    Board.Registry.BoardSession
    |> Registry.keys(pid)
  end
end
