defmodule TileTest do
  use ExUnit.Case

  test "knows what entities are occupying it (when empty)" do
    tile = Tile.init(0, 0)
    assert Tile.occupied?(tile) == false
  end

  test "knows what entities are occupying it (when one entity is within it)" do
    tile = Tile.init(0, 0)
    tile = tile |> Tile.add_occupant(1)
    assert Tile.occupied?(tile)
  end

  test "removing occupants" do
    tile = Tile.init(0, 0)
    tile = tile |> Tile.add_occupant(1)
    tile = tile |> Tile.remove_occupant(1)
    assert !Tile.occupied?(tile)
  end
end
