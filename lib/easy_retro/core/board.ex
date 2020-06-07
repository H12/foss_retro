defmodule EasyRetro.Core.Board do
  defstruct [:key, :title, cards: %{}, categories: []]

  def new(title) do
    %__MODULE__{
      key: generate_key(),
      title: title
    }
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
