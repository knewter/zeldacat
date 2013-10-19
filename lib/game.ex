#####################################################################
###         Circles
###
### @doc This is an ErlWorld example scenario of Circles moving around
### the screen.
###
### You can add circles by left-clicking anywhere in the window. The
### circles will be created in the direction that the mouse was last
### moving in. The circles are constantly pulled down by gravity.
###
### @author Joseph Lenton - JL235@Kent.ac.uk
### ported to Elixir by Josh Adams - josh.rubyist@gmail.com
### see http://elixirsips.com for more.
#####################################################################
defmodule Game do
  # values for setting up the display
  def width, do: 800
  def height, do: 600
  def title, do: "Zeldacat"

  # the name of the random number generator
  def random, do: :random_server

  # values for calculating random numbers
  def size_min, do: 4
  def size_max, do: 36

  def color_min, do: 0.4
  def color_max, do: 0.8

  def speed_min, do: 1.5
  def speed_max, do: 2.5

  # the minimum amount of time that must pass between creating circles, in _microseconds_
  def min_timeout, do: 50_000

  def gravity, do: 0.0000098

  #          start
  #
  # @doc Starts the Circles scenario.
  # @spec start() -> ok
  def start do
    random_server = :rand.new()
    :erlang.register( random, random_server )

    display    = :display.new( width, height, :binary.bin_to_list(title) )
    main_loop  = :mainloop.new( display )
    circle_img = :image.new( display, :binary.bin_to_list("circle.png") )
    :mainloop.run( main_loop, new_world(circle_img) )
  end

  #          new_world
  #
  # @doc Creates and returns a World actor ready and setup for running the scenario.
  # @spec new_world(CircleImg::image()) -> Game::world()
  defp new_world(circle_img) do
    act_fun = fn(state, _p) -> :world_state.act_actors(state) end
    paint_fun = fn(state, g) ->
      :graphics.set_clear_color(g, :color.white)
      :world_state.paint_actors(state, g)
      IO.puts("Actors: #{:world_state.get_number_actors(state)}")
    end
    world = :world.new(act_fun, paint_fun)
    :world.add_actor( world, new_mouse(circle_img) )
    world
  end

  #          new_mouse
  #
  # @doc Creates the mouse actor that will listen to input and create the circles.
  # @spec new_mouse(CircleImg::image()) -> Mouse::actor()
  defp new_mouse(circle_img) do
    act = fn(as, parent) ->
      controls = :actor.get_controls(parent)
      last_location = :actor_state.get_xy(as)
      location = :controls.get_mouse_xy(controls)
      last_time = :actor_state.get(as, :last_time)
      now = :erlang.now()
      diff = :timer.now_diff(now, last_time)

      new_as = case (diff > min_timeout) do
        true ->
          is_button_press = :controls.is_mouse_down(controls, :left)
          add_circle( parent, circle_img, location, last_location, is_button_press )
          :actor_state.set( as, :last_time, now )
        false -> as
      end

      :actor_state.set_xy(
        :actor_state.set(new_as, :last_location, last_location),
        location
      )
    end

    paint = fn(_as, _g) -> :ok end
    state = :actor_state.new([
      { :last_location, {0, 0}         },
      { :last_time,     :erlang.now()  }
    ])
    :actor.new( act, paint, state )
  end

  #          add_circle
  #
  # @doc If the mouse is pressed, then this will add the circle to the given world.
  # @spec add_circle( World::world(), CircleImg::image(), Location::{X, Y}, LastLocation::{X, Y}, IsMouseDown::boolean() ) -> ok
  defp add_circle( world, circle_img,  location, last_location, true ) do
    circle = new_circle( circle_img, location, locations_to_angle(last_location, location) )
    :world.add_actor( world, circle )
  end
  defp add_circle( _world, _circle_img, _location, _last_location, false), do: :ok

  #          locations_to_angle
  #
  # @doc Converts the two locations given to an angle from the first location to the second.
  # The angle is in radians.
  #
  # @spec locations_to_angle( {X, Y}, {ToX, ToY} ) -> Angle::number()
  defp locations_to_angle( {x, y}, {to_x, to_y} ), do: :math.atan2( to_y-y, to_x-x )

  #          new_circle
  #
  # @doc Returns a new circle actor at the given location moving in the given direction.
  # @spec new_circle( CircleImg::image(), XY::{number(), number()}, Angle::number() ) -> Circle::actor()
  defp new_circle(circle_img, xy, angle) do
    speed  = random_speed()
    radius = random_radius()
    color  = { random_color, random_color, random_color, random_color }
    size   = { radius*2, radius*2 }
    weight = radius*radius*:math.pi()
    delta  = { speed*:math.cos(angle), speed*:math.sin(angle) }
    gravity = weight_to_delta(weight)

    state  = :actor_state.new( :circle, xy, size, [{ :delta  , delta  }])

    act = fn( as, _parent ) ->
      {delta_x, delta_y} = :actor_state.get( as, :delta )
      { x, y } = :actor_state.get_xy( as )

      {new_delta_x, new_x} = update_delta( delta_x, x, radius, width )
      {new_delta_y, new_y} = update_delta( delta_y+gravity, y, radius, height )

      new_as = :actor_state.set_xy( as, new_x, new_y )
      :actor_state.set( new_as, :delta, {new_delta_x, new_delta_y} )
    end

    paint = fn( as, g ) ->
      :graphics.set_color( g, color )
      :graphics.draw_image( g, circle_img, :actor_state.get_xy(as), :actor_state.get_size(as), true )
    end

    :actor.new( act, paint, state )
  end

  #          weight_to_delta
  #
  # @doc Given a weight value this will return how much force will be pulling
  # down on it in this circles scenario.
  # @spec weight_to_delta( Weight::number() ) -> Force::number()
  defp weight_to_delta(weight), do: gravity * weight

  #          update_delta
  #
  # @doc A helper function for updating both the movement and position of an X or
  # Y value. If the value is outside the radius or length-radius then it will be
  # returned to whichever value is closer with the delta inverted.
  #
  # Otherwise the same delta given is also returned and the value given is
  # returned with the delta value added on to it.
  #
  # @spec update_delta( Detla::number(), Val::number(), Radius::number(), Length::number() ) -> { NewDelta::number(), NewVal::number() }
  defp update_delta( delta, val, radius, _length ) when (val < radius) do
    {-1 * delta * 0.95, radius }
  end
  defp update_delta( delta, val, radius, length ) when (val > length-radius) do
    {delta * 0.95, length-radius }
  end
  defp update_delta( delta, val, _radius, _length ) do
    {delta, val+delta}
  end

  #          update_delta
  #
  # @doc A helper function for updating both the movement and position of an X or
  # Y value. If the value is outside the radius or length-radius then it will be
  # returned to whichever value is closer with the delta inverted.
  #
  # Otherwise the same delta given is also returned and the value given is
  # returned with the delta value added on to it.
  #
  # @spec update_delta( Detla::number(), Val::number(), Radius::number(), Length::number() ) -> { NewDelta::number(), NewVal::number() }
  defp random_radius do
    :rand.random(random, size_min, size_max)
  end

  #          random_color
  #
  # @doc Returns a random number to use for random colour components.
  # @spec random_color() -> number()
  defp random_color do
    :rand.random(random, color_min, color_max)
  end

  #          random_speed
  #
  # @doc Returns a random number to use for starting circle speeds.
  # @spec random_speed() -> number()
  defp random_speed do
    :rand.random(random, speed_min, speed_max)
  end
end
