defmodule EasyRetro.Core.Card do
  defstruct [:id, :content, :creator, comments: [], votes: 0]

  @doc """
  Creates a new card.

  ## Parameters
    - id: An identifier that allows boundary services to distinguish between different cards
    - content: The text content of the new card
    - creator: An optional field that allows boundary services to identify who created a particular card

  ## Examples

      iex> card = __MODULE__.new(0, "Test content", "123")
      iex> card.id
      0
      iex> card.content
      "Test content"
      iex> card.creator
      "123"
  """
  def new(id, content, creator_id \\ nil) do
    %__MODULE__{
      id: id,
      content: content,
      creator: creator_id
    }
  end

  def add_vote(card) do
    update_in(card.votes, &(&1 + 1))
  end

  def remove_vote(card) do
    update_in(card.votes, &(&1 - 1))
  end
end
