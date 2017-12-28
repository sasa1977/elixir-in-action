defmodule TodoCacheTest do
  use ExUnit.Case, async: false

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
    entries = Todo.Server.entries(alice, ~D[2018-12-19])
    assert [%{date: ~D[2018-12-19], title: "Dentist"}] = entries

    GenServer.stop(cache)
  end

  test "persistence" do
    {:ok, cache} = Todo.Cache.start()

    john = Todo.Cache.server_process(cache, "john")
    Todo.Server.add_entry(john, %{date: ~D[2018-12-20], title: "Shopping"})
    assert 1 == length(Todo.Server.entries(john, ~D[2018-12-20]))

    GenServer.stop(cache)
    {:ok, cache} = Todo.Cache.start()

    entries =
      cache
      |> Todo.Cache.server_process("john")
      |> Todo.Server.entries(~D[2018-12-20])

    assert [%{date: ~D[2018-12-20], title: "Shopping"}] = entries
  end
end
