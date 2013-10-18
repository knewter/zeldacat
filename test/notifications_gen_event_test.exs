defmodule NotificationsEventHandler do
  use GenEvent.Behaviour

  # Callbacks

  def init(_) do
    { :ok, [] }
  end

  def handle_event({:notification, x}, notifications) do
    { :ok, [x|notifications] }
  end

  def handle_call(:notifications, notifications) do
    {:ok, Enum.reverse(notifications), []}
  end
end

defmodule NotificationsGenEventTest do
  use ExUnit.Case

  test "how it works" do
    { :ok, pid } = :gen_event.start_link
    #=> {:ok,#PID<0.42.0>}

    :gen_event.add_handler(pid, NotificationsEventHandler, [])
    #=> :ok

    :gen_event.notify(pid, {:notification, 1})
    #=> :ok

    :gen_event.notify(pid, {:notification, 2})
    #=> :ok

    notifications = :gen_event.call(pid, MyEventHandler, :notifications)
    assert notifications == [1, 2]
    #=> [1, 2]

    notifications = :gen_event.call(pid, MyEventHandler, :notifications)
    assert notifications = []
    #=> []
  end
end

