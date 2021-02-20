defmodule Helpers do
  def copy(term) do
    text =
      if is_binary(term) do
        term
      else
        inspect(term, limit: :infinity, pretty: true)
      end

    port = Port.open({:spawn, "pbcopy"}, [])
    true = Port.command(port, text)
    true = Port.close(port)

    :ok
  end
end

# Module Aliases
alias EasyRetro.Core.Board
alias EasyRetro.Core.Card

# Helpful variable setup
sample_board =
  Board.new("Sample Board")
  |> Board.add_category("Cats")
  |> Board.add_category("Dergs")
  |> Board.add_card(0, "Maru")
  |> Board.add_card(0, "Lil Bub")
  |> Board.add_card(0, "Grumpy")
  |> Board.add_card(1, "Boo")
  |> Board.add_card(1, "Big Red")
  |> Board.add_card(1, "Marnie")
  |> Board.add_voter(0)
  |> Board.add_vote(0, 0)
  |> Board.add_vote(0, 1)
  |> Board.add_vote(0, 5)
  |> Board.add_voter(1)
  |> Board.add_vote(1, 1)
  |> Board.add_vote(1, 2)
  |> Board.add_vote(1, 3)
  |> Board.add_voter(2)
  |> Board.add_vote(2, 0)
  |> Board.add_vote(2, 1)
  |> Board.add_vote(2, 2)
