defmodule Tile do
  defstruct x: nil, y: nil, occupants: []

  def init(x, y) do
    %Tile{x: x, y: y, occupants: []}
  end

  def occupied?(tile) do
    Enum.any?(tile.occupants)
  end

  def add_occupant(tile, occupant) do
    %Tile{tile | occupants: [occupant | tile.occupants]}
  end

  def remove_occupant(tile, occupant) do
    new_occupants = tile.occupants |> Enum.reject(fn(x) ->
      x == occupant
    end)
    %Tile{tile | occupants: new_occupants}
  end
end
