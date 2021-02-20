defmodule EasyRetro.Core.Board do
  @moduledoc """
  Functions for creating and interacting with EasyRetro's primary data structure: The Board.

  ## Example

      iex> Board.new("Kitty Board")
      ...> |> Board.add_category("Cats")
      ...> |> Board.add_card(0, "Maru")
      ...> |> Board.add_card(0, "Lil Bub")
      ...> |> Board.add_voter(0)
      ...> |> Board.add_vote(0, 0)
      %EasyRetro.Core.Board{
        card_count: 2,
        cards: %{
          0 => %EasyRetro.Core.Card{comments: [], content: "Maru", id: 0, votes: 1},
          1 => %EasyRetro.Core.Card{comments: [], content: "Lil Bub", id: 1, votes: 0}
        },
        categories: %{0 => %{cards: [1, 0], name: "Cats"}},
        key: "ABC12",
        title: "Sample Board",
        voters: %{0 => [0]}
      }

  In the example above, we created a Board with the title "Kitty Board", a category for "Cats". We
  then added two Cards to that category, one with the content "Maru" and another with "Lil Bub".
  Subsequently, we added a voter with an id of `0`, and then that voter added a vote to the "Maru"
  card by referencing its index.

  Categories and Cards are zero-indexed automatically, but voters must be supplied with a unique
  identifier. This allows for voter/user uniqueness to be managed client-side with things like
  browser session tokens.

  The methodology for indexing Cards and categories differs slightly between the two. Cards are
  indexed off of the `card_count` parameter on the Board. The `card_count` is only ever incremented,
  which ensures a Card id always refers to the same Card, which is important since those ids are
  referenced by both the category and voter parameters. Since categories aren't referenced by anything
  within the Board struct, their ids can be indexed off of the dynamic `map_size/1` of the `categories`
  Map without adding any undue complications.

  Categories are represented as Maps, containing a List of Card ids in addition to its title. Votes
  are tracked via a "voters" Map, containing entries that each use the unique voter identifier (provided
  via the `Board.add_voter/2` method) as a key, with the corresponding value being a List of Card ids
  for which the voter has voted.

  __See the EasyRetro.Core.Card module for more info on how Cards are structured.__

  """

  alias EasyRetro.Core.Card

  defstruct [:key, :title, card_count: 0, cards: %{}, categories: %{}, voters: %{}]

  def new(title) do
    %__MODULE__{
      key: generate_key(),
      title: title
    }
  end

  def as_markdown(%__MODULE__{title: title, categories: categories, cards: cards}) do
    ""
    |> concat_line("#", title)
    |> concat_content(categories, cards)
    |> String.trim()
  end

  defp concat_content(string, categories, cards) do
    categories
    |> Map.values()
    |> Enum.reduce(string, &concat_category(&2, &1, cards))
  end

  defp concat_category(string, %{name: category_name, cards: card_ids}, cards) do
    string
    |> concat_line("##", category_name)
    |> concat_cards(card_ids, cards)
  end

  defp concat_cards(string, card_ids, cards) do
    card_ids
    |> Enum.map(fn card_id -> cards[card_id] end)
    |> Enum.sort_by(fn %{votes: votes} -> votes end, :desc)
    |> IO.inspect()
    |> Enum.reduce(string, &concat_card(&2, &1))
  end

  defp concat_card(str, %Card{content: card_content, votes: vote_count}) do
    concat_line(str, "###", "#{vote_count} - #{card_content}")
  end

  defp concat_line(str, prefix, content), do: str <> prefix <> " " <> content <> "\n"

  @spec add_card(map(), integer(), binary()) :: map()
  def add_card(board, category_id, content) do
    new_card_id = board.card_count

    board
    |> put_in(card_path(new_card_id), Card.new(new_card_id, content))
    |> update_in(category_cards_path(category_id), &[new_card_id | &1])
    |> Map.put(:card_count, board.card_count + 1)
  end

  def remove_card(board, category_id, card_id) do
    board
    |> update_in(category_cards_path(category_id), &List.delete(&1, card_id))
    |> pop_in(card_path(card_id))
    |> elem(1)
  end

  def add_category(board, name) do
    put_in(board.categories[map_size(board.categories)], %{name: name, cards: []})
  end

  def add_voter(board, voter_id) do
    maybe_add_voter(board, voter_id)
  end

  def add_vote(board, voter_id, card_id) do
    board
    |> update_in(card_path(card_id), &Card.add_vote/1)
    |> maybe_add_voter(voter_id)
    |> update_in(voter_path(voter_id), &[card_id | &1])
  end

  def remove_vote(board, voter_id, card_id) do
    maybe_remove_vote(board, voter_id, card_id)
  end

  defp maybe_add_voter(board, voter_id) do
    if is_list(board.voters[voter_id]) do
      board
    else
      put_in(board.voters[voter_id], [])
    end
  end

  defp maybe_remove_vote(board, voter_id, card_id) do
    if Enum.member?(board.voters[voter_id], card_id) do
      board
      |> update_in(card_path(card_id), &Card.remove_vote/1)
      |> update_in(voter_path(voter_id), &List.delete(&1, card_id))
    else
      board
    end
  end

  defp voter_path(voter_id), do: [:voters, voter_id] |> Enum.map(&Access.key/1)

  defp card_path(card_id), do: [:cards, card_id] |> Enum.map(&Access.key/1)

  defp category_cards_path(category_id) do
    [:categories, category_id, :cards] |> Enum.map(&Access.key/1)
  end

  defp generate_key(key_length \\ 5) do
    min = String.duplicate("1", key_length) |> String.to_integer(36)
    max = String.duplicate("Z", key_length) |> String.to_integer(36)

    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
  end
end
