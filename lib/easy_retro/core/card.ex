defmodule EasyRetro.Core.Card do
  defstruct [:id, :content, collapsed: true, comments: [], votes: 0]

  def new(id, content) do
    %__MODULE__{
      id: id,
      content: content
    }
  end

  def add_comment(card, comment) do
    Map.replace!(card, :comments, [comment | card.comments])
  end
end
