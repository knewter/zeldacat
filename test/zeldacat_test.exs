# This module should exercise the whole system - basically an integration test, but still using ExUnit because ???
defmodule ZeldacatTest do
  use ExUnit.Case

  test "something with a health component can die" do
    # Create Entity, add health component, then kill it!
    {:ok, entity} = Entity.init()
    Entity.add_component(entity, HealthComponent, 100)
    assert HealthComponent.get_hp(entity) == 100
    assert HealthComponent.alive?(entity) == true
    Entity.notify(entity, {:hit, 50})
    assert HealthComponent.get_hp(entity) == 50
    Entity.notify(entity, {:hit, 50})
    assert HealthComponent.alive?(entity) == false
  end
end
