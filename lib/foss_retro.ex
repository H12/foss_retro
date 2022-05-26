defmodule FossRetro do
  @moduledoc """
  The main API for interacting with FossRetro's OTP business logic.
  """
  use Boundary, deps: [], exports: [Core.Board]

  alias FossRetro.Boundary.{BoardManager, BoardSession}
  alias FossRetro.Core.Board

  @topic inspect(__MODULE__)

  @doc """
  Subscribes the calling process to FossRetro.PubSub
  """
  def subscribe() do
    Phoenix.PubSub.subscribe(FossRetro.PubSub, @topic)
  end

  @doc """
  Builds a Board struct from a given title, starts a new BoardSession process,
  and notifies any PubSub subscribers that the board was built.

  ## Parameters
    - title: String that represents the title of the new Board

  ## Examples

      iex> %Board{title: title} = FossRetro.build_board("Title")
      iex> title
      "Title"
  """
  @spec build_board(String.t()) :: Board.t()
  def build_board(title) do
    title
    |> BoardManager.build_board()
    |> start_retro
    |> notify_subscribers([:board, :built])
  end

  defp start_retro(board) do
    case BoardSession.start_retro(board) do
      {:ok, _} -> board
      error -> error
    end
  end

  @doc """
  Returns a Map of all the Board structs that have been created.

  ## Examples

      iex> FossRetro.list_boards() |> map_size()
      0
      iex> FossRetro.build_board("Title")
      iex> FossRetro.list_boards() |> map_size()
      1
  """
  @spec list_boards() :: %{required(String.t()) => Board.t()}
  def list_boards do
    BoardManager.list_boards()
  end

  @doc """
  Given a unique Board key, returns the corresponding Board struct.

  ## Parameters
    - key: String that represents the unique `key` on a Board struct

  ## Examples

      iex> new_board = FossRetro.build_board("New Board")
      iex> found_board = FossRetro.lookup_board_by_key(new_board.key)
      iex> new_board == found_board
      true
  """
  @spec lookup_board_by_key(String.t()) :: Board.t() | nil
  def lookup_board_by_key(key) do
    BoardManager.lookup_board_by_key(key)
  end

  @doc """
  Adds a Card to the provided Board and notifies PubSub subscribers of the change.

  ## Parameters
    - board: Board struct to which the new Card will be added
    - category_key: Integer identifying the target category of the new Card
    - card_content: String representing the content of the new Card
    - creator_id: String representing the identifier of the new Card's creator

  ## Examples

      iex> cat_board = "Animals"
      ...> |> FossRetro.build_board()
      ...> |> FossRetro.add_category("Cats")
      iex> cat_board.cards
      %{}
      iex> cat_board.categories
      %{0 => %{name: "Cats", cards: []}}
      iex> cat_board = FossRetro.add_card(cat_board, 0, "Maru", "creator")
      iex> cat_board.cards
      %{0 => %Card{id: 0, content: "Maru", creator: "creator"}}
      iex> cat_board.categories
      %{0 => %{name: "Cats", cards: [0]}}
  """
  @spec add_card(Board.t(), non_neg_integer, String.t(), String.t()) :: Board.t()
  def add_card(board, category_key, card_content, creator_id) do
    board
    |> BoardSession.add_card(category_key, card_content, creator_id)
    |> BoardManager.update_board()
    |> notify_subscribers([:board, :updated])
  end

  @doc """
  Removes a Card from the provided Board and notifies PubSub subscribers of the
  change.

  ## Parameters
    - board: Board struct from which the intended Card will be removed
    - category_key: Integer representing the category of the target Card
    - card_index: Integer representing the index of the target Card

  ## Examples

      iex> cat_board = "Animals"
      ...> |> FossRetro.build_board()
      ...> |> FossRetro.add_category("Cats")
      ...> |> FossRetro.add_card(0, "Maru", "creator")
      iex> cat_board.cards
      %{0 => %Card{id: 0, content: "Maru", creator: "creator"}}
      iex> cat_board.categories
      %{0 => %{name: "Cats", cards: [0]}}
      iex> cat_board = FossRetro.remove_card(cat_board, 0, 0)
      iex> cat_board.cards
      %{}
      iex> cat_board.categories
      %{0 => %{name: "Cats", cards: []}}
  """
  @spec remove_card(Board.t(), non_neg_integer(), non_neg_integer()) :: Board.t()
  def remove_card(board, category_key, card_index) do
    board
    |> BoardSession.remove_card(category_key, card_index)
    |> BoardManager.update_board()
    |> notify_subscribers([:board, :updated])
  end

  @doc """
  Adds a category to the provided board and notifies PubSub subscribers of the
  change.

  ## Parameters
    - board: Board struct from which the intended Card will be removed
    - category_key: Integer representing the category of the target Card

  ## Examples

      iex> cat_board = FossRetro.build_board("Animals")
      iex> cat_board.categories
      %{}
      iex> cat_board = FossRetro.add_category(cat_board, "Cats")
      iex> cat_board.categories
      iex> cat_board.categories
      %{0 => %{name: "Cats", cards: []}}
  """
  @spec add_category(Board.t(), String.t()) :: Board.t()
  def add_category(board, category_name) do
    board
    |> BoardSession.add_category(category_name)
    |> BoardManager.update_board()
    |> notify_subscribers([:board, :updated])
  end

  @doc """
  Adds a voter if they don't yet exist on the board, is a no-op otherwise.

  ## Parameters
    - board: Board struct to which to add the voter
    - voter_id: A String that identifies a specific voter

  ## Examples

      iex> cat_board = FossRetro.build_board("Animals")
      iex> cat_board.voters
      %{}
      iex> cat_board = FossRetro.add_voter(cat_board, "ANewUser")
      iex> cat_board.voters
      %{"ANewUser" => []}
  """
  @spec add_voter(Board.t(), String.t()) :: Board.t()
  def add_voter(board, voter_id) do
    board
    |> BoardSession.add_voter(voter_id)
    |> BoardManager.update_board()
    |> notify_subscribers([:board, :updated])
  end

  @doc """
  Increments the number of votes on a given card, and records that vote for the
  relevant voter. If a voter with the provided identifier does not exist, a new
  voter will be added using that identifier.

  ## Parameters
    - board: Board struct containing the target Card
    - voter_id: A String that identifies a specific voter
    - card_id: A non-negative integer corresponding to a particular card

  ## Examples

      iex> cat_board = "Animals"
      ...> |> FossRetro.build_board()
      ...> |> FossRetro.add_category("Cats")
      ...> |> FossRetro.add_card(0, "Maru", "creator")
      ...> |> FossRetro.add_card(0, "Garfield", "creator")
      iex> cat_board.cards[0]
      %Card{id: 0, content: "Maru", votes: 0, creator: "creator"}
      iex> cat_board.cards[1]
      %Card{id: 1, content: "Garfield", votes: 0, creator: "creator"}
      iex> cat_board.voters
      %{}
      iex> cat_board = FossRetro.add_vote(cat_board, "ANewUser", 0)
      iex> cat_board.cards[0]
      %Card{id: 0, content: "Maru", votes: 1, creator: "creator"}
      iex> cat_board.cards[1]
      %Card{id: 1, content: "Garfield", votes: 0, creator: "creator"}
      iex> cat_board.voters
      %{"ANewUser" => [0]}
  """
  @spec add_vote(Board.t(), String.t(), non_neg_integer()) :: Board.t()
  def add_vote(board, voter_id, card_id) do
    board
    |> BoardSession.add_vote(voter_id, card_id)
    |> BoardManager.update_board()
    |> notify_subscribers([:board, :updated])
  end

  @doc """
  Decrements the number of votes on a given card, and removes the record of
  that vote for the relevant voter. If the voter has not voted on the target
  card, this is just a no-op.

  ## Parameters
    - board: Board struct containing the target Card
    - voter_id: A String that identifies a specific voter
    - card_id: A non-negative integer corresponding to a particular card

  ## Examples

      iex> cat_board = "Animals"
      ...> |> FossRetro.build_board()
      ...> |> FossRetro.add_category("Cats")
      ...> |> FossRetro.add_card(0, "Maru", "creator")
      ...> |> FossRetro.add_card(0, "Garfield", "creator")
      ...> |> FossRetro.add_vote("ANewUser", 0)
      iex> cat_board.cards[0]
      %Card{id: 0, content: "Maru", votes: 1, creator: "creator"}
      iex> cat_board.cards[1]
      %Card{id: 1, content: "Garfield", votes: 0, creator: "creator"}
      iex> cat_board.voters
      %{"ANewUser" => [0]}
      iex> cat_board = FossRetro.remove_vote(cat_board, "ANewUser", 0)
      iex> cat_board = FossRetro.remove_vote(cat_board, "ANewUser", 1)
      iex> cat_board.cards[0]
      %Card{id: 0, content: "Maru", votes: 0, creator: "creator"}
      iex> cat_board.cards[1]
      %Card{id: 1, content: "Garfield", votes: 0, creator: "creator"}
      iex> cat_board.voters
      %{"ANewUser" => []}
  """
  @spec remove_vote(Board.t(), String.t(), non_neg_integer()) :: Board.t()
  def remove_vote(board, voter_id, card_id) do
    board
    |> BoardSession.remove_vote(voter_id, card_id)
    |> BoardManager.update_board()
    |> notify_subscribers([:board, :updated])
  end

  defp notify_subscribers({:ok, key}, event) do
    board = lookup_board_by_key(key)
    Phoenix.PubSub.broadcast(FossRetro.PubSub, @topic, {__MODULE__, event, board})
    board
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}

  defp notify_subscribers(%Board{key: key}, event), do: notify_subscribers({:ok, key}, event)

  defp notify_subscribers({_title, key}, event), do: notify_subscribers({:ok, key}, event)
end
