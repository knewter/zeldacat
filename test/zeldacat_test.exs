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
    Entity.notify(entity, {:heal, 25})
    assert HealthComponent.get_hp(entity) == 75
    Entity.notify(entity, {:hit, 75})
    assert HealthComponent.get_hp(entity) == 0
    assert HealthComponent.alive?(entity) == false
  end

  test "something with an XYComponent can move around" do
    {:ok, entity} = Entity.init()
    Entity.add_component(entity, XYComponent, {50, 50})
    Entity.notify(entity, {:move, {:y, 35}})
    assert XYComponent.get_position(entity) == {50, 35}
  end

  test "something with a WeaponComponent can manage a list of weapons" do
    {:ok, entity} = Entity.init()
    Entity.add_component(entity, WeaponComponent, [])
    Entity.notify(entity, {:add_weapon, "bat"})
    assert WeaponComponent.list_weapons(entity) == ["bat"]
    Entity.notify(entity, {:add_weapon, "screwdriver"})
    assert WeaponComponent.list_weapons(entity) == ["bat", "screwdriver"]
  end

  test "one entity can find out if another one is in the same space" do
    {:ok, boulder} = Entity.init()
    {:ok, kitty} = Entity.init()
    Entity.add_component(boulder, XYComponent, {50, 50})
    Entity.add_component(kitty, XYComponent, {49, 50})
    assert XYComponent.occupied?(kitty, {50, 50}) == true
    assert XYComponent.occupied?(kitty, {40, 50}) == false
  end
end
