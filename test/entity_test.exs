defmodule EntityTest do
  use ExUnit.Case

  test "can spawn a new entity" do
    {:ok, pid} = Entity.spawn_link
    assert pid != 
  end
end
