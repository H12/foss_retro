defmodule FossRetroTest do
  use ExUnit.Case, async: true
  alias FossRetro.Core.{Board, Card}
  doctest FossRetro

  setup do
    Application.stop(:foss_retro)
    :ok = Application.start(:foss_retro)
  end
end
