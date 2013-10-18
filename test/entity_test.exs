defmodule EntityTest do
  use ExUnit.Case

  test "can spawn a new entity" do
    {:ok, entity} = Entity.init
    assert entity != nil
  end

  test "can add a component" do
    {:ok, entity} = Entity.init
    Entity.add_component(entity, HealthComponent, 100)
  end
end
