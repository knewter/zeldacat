defmodule BoardTest do
  use ExUnit.Case

  test "board can be initialized" do
    {:ok, pid} = Board.start_link([200, 200])
    assert is_pid(pid)
  end

  test "board can return a tile at a given location" do
    {:ok, pid} = Board.start_link([200, 200])
    tile = pid |> Board.get_tile(0, 1)
    assert tile.x == 0
    assert tile.y == 1
  end

  test "board can add occupants to a given tile" do
    {:ok, pid} = Board.start_link([200, 200])
    pid |> Board.add_occupant(0, 1, :giggity)
    tile = pid |> Board.get_tile(0, 1)
    assert tile.occupants |> Enum.member?(:giggity)
  end

  test "board can remove occupants from a given tile" do
    {:ok, pid} = Board.start_link([200, 200])
    pid |> Board.add_occupant(0, 1, :giggity)
    pid |> Board.remove_occupant(0, 1, :giggity)
    tile = pid |> Board.get_tile(0, 1)
    assert !(tile.occupants |> Enum.member?(:giggity))
  end
end
