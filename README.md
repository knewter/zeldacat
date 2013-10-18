# Zeldacat

This is an implementation of an overhead view game engine in Elixir, in which
each entity in the game is a generic process and we use `GenEvent.Behaviour` to
add various components to those processes, such as:

- `HealthComponent`
- `XYComponent`
- `ItemsBagComponent`
- `AttackComponent`

This is based on the code in [`events_and_logging` from ErlangCamp
2013](https://github.com/erlware/erlang-camp/tree/master/events_and_logs/entity_manager).

It will not initially contain any graphical interface.  My goal is for this to
be a library that another project can pull in, where that project might layer a
graphical interface on top of it (either by using ErlWorld or by building an
angularjs/websockets game engine)
