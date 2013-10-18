defmodule HealthComponent do
  ### Public API
  def alive?(entity) do
    :gen_event.call(entity, HealthComponent, :alive?)
  end

  ### GenEvent API
  def init(hp) do
    { :ok, hp }
  end

  def handle_call(:alive?, hp) do
    {:ok, true, hp}
  end
end
