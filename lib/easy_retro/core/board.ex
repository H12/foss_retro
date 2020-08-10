defmodule EasyRetro.Core.Board do
  alias EasyRetro.Core.Card

  defstruct [:key, :title, card_count: 0, cards: %{}, categories: %{}, voters: %{}]

  def new(title) do
    %__MODULE__{
      key: generate_key(),
      title: title
    }
  end

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
