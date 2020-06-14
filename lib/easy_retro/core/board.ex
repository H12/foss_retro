defmodule EasyRetro.Core.Board do
  alias EasyRetro.Core.Card

  defstruct [:key, :title, card_count: 0, cards: %{}, categories: %{}]

  def new(title) do
    %__MODULE__{
      key: generate_key(),
      title: title
    }
  end

  @spec add_card(map(), integer(), binary()) :: map()
  def add_card(board, category_key, content) do
    new_card = Card.new(board.card_count, content)

    old_cards = Map.get(board.cards, category_key)
    new_cards = Map.put(board.cards, category_key, [new_card | old_cards])

    board
    |> Map.put(:cards, new_cards)
    |> Map.put(:card_count, board.card_count + 1)
  end

  def add_category(board, name) do
    old_cards = board.cards
    old_categories = board.categories

    board
    |> Map.put(:categories, Map.put(old_categories, map_size(old_categories), name))
    |> Map.put(:cards, Map.put(old_cards, map_size(old_cards), []))
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
