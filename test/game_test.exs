defmodule GameTest do
  use ExUnit.Case

  test "module variables" do
    assert Game.width == 800
    assert Game.height == 600
    assert Game.title == "Zeldacat"
  end
end
