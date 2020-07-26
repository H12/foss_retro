defmodule EasyRetroTest do
  use ExUnit.Case, async: true
  alias EasyRetro.Core.{Board, Card}
  doctest EasyRetro

  setup do
    Application.stop(:easy_retro)
    :ok = Application.start(:easy_retro)
  end
end
