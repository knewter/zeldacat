defmodule XYComponent do
  use GenEvent.Behaviour

  ### Public API
  def get_position(entity) do
    :gen_event.call(entity, XYComponent, :get_position)
  end

  ### GenEvent API
  # position is a tuple whose first element is the x component and whose second element is the y component
  def init(position) do
    { :ok, position }
  end

  def handle_event({:move, {:x, new_x}}, position) do
    {_, y} = position
    {:ok, {new_x, y}}
  end
  def handle_event({:move, {:y, new_y}}, position) do
    {x, _} = position
    {:ok, {x, new_y}}
  end

  def handle_call(:get_position, position) do
    {:ok, position, position}
  end
  def handle_call(:occupied?, position) do
  end
end
