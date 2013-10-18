defmodule Entity do
  ### Public API
  def init do
    :gen_event.start_link()
  end

  def add_component(pid, component, state) do
  end
end
