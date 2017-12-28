defmodule TodoCacheTest do
  use ExUnit.Case, async: true

  test "mapping of list names to pids" do
    {:ok, cache} = Todo.Cache.start()

    bob_pid = Todo.Cache.server_process(cache, "bob")

    assert bob_pid != Todo.Cache.server_process(cache, "alice")
    assert bob_pid == Todo.Cache.server_process(cache, "bob")

    GenServer.stop(cache)
  end

  test "to-do requests" do
    {:ok, cache} = Todo.Cache.start()

    alice = Todo.Cache.server_process(cache, "alice")
    Todo.Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Dentist"})

    assert [%{date: ~D[2018-12-19], title: "Dentist"}] =
             Todo.Server.entries(alice, ~D[2018-12-19])

    GenServer.stop(cache)
  end
end
