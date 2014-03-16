defmodule Board.State, do: defstruct [tiles: []]

defmodule Board do
  use ExActor.GenServer

  definit [width, height] do
    initial_state %Board.State{tiles: build_board(width, height)}
  end

  defcall get_tile(x, y), state: state do
    reply(state |> tile_at(x, y))
  end

  defcast add_occupant(x, y, occupant), state: state do
    new_state(state |> update_tile(x, y, fn(t) -> t |> Tile.add_occupant(occupant) end))
  end

  defcast remove_occupant(x, y, occupant), state: state do
    new_state(state |> update_tile(x, y, fn(t) -> t |> Tile.remove_occupant(occupant) end))
  end

  defp build_board(width, height) do
    output = build_rows(width, height)
    output
  end

  defp build_rows(width, height), do: build_rows(width, height, [])
  defp build_rows(_width, 0, acc), do: acc
  defp build_rows(width, height, acc) do
    build_rows(width, height-1, [build_row(width, height) | acc])
  end

  defp build_row(width, y), do: build_row(width, y, [])
  defp build_row(0, _y, acc), do: acc
  defp build_row(width, y, acc) do
    build_row(width-1, y, [%Tile{x: width-1, y: y-1} | acc])
  end

  defp tile_at(state, x, y) do
    state.tiles
      |> Enum.at(y)
      |> Enum.at(x)
  end

  defp update_tile(state, x, y, update_fun) do
    row = state.tiles |> Enum.at(y) |> List.update_at(x, update_fun)
    %Board.State{state | tiles: state.tiles |> List.replace_at(y, row)}
  end
end
