defmodule TodoCacheTest do
  use ExUnit.Case, async: false

  test "mapping of list names to pids" do
    {:ok, supervisor} = Todo.System.start_link()

    bob_pid = Todo.Cache.server_process("bob")

    assert bob_pid != Todo.Cache.server_process("alice")
    assert bob_pid == Todo.Cache.server_process("bob")

    Supervisor.stop(supervisor)
  end

  test "to-do requests" do
    {:ok, supervisor} = Todo.System.start_link()

    alice = Todo.Cache.server_process("alice")
    Todo.Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Dentist"})
    entries = Todo.Server.entries(alice, ~D[2018-12-19])
    assert [%{date: ~D[2018-12-19], title: "Dentist"}] = entries

    Supervisor.stop(supervisor)
  end

  test "persistence" do
    {:ok, supervisor} = Todo.System.start_link()

    john = Todo.Cache.server_process("john")
    Todo.Server.add_entry(john, %{date: ~D[2018-12-20], title: "Shopping"})
    assert 1 == length(Todo.Server.entries(john, ~D[2018-12-20]))

    Supervisor.stop(supervisor)
    {:ok, supervisor} = Todo.System.start_link()

    entries =
      "john"
      |> Todo.Cache.server_process()
      |> Todo.Server.entries(~D[2018-12-20])

    assert [%{date: ~D[2018-12-20], title: "Shopping"}] = entries
  end
end
