defmodule EasyRetro.Core.Card do
  defstruct [:id, :content, comments: [], votes: 0]

  def new(id, content) do
    %__MODULE__{
      id: id,
      content: content
    }
  end

  def add_vote(card) do
    update_in(card.votes, &(&1 + 1))
  end

  def remove_vote(card) do
    update_in(card.votes, &(&1 - 1))
  end
end
