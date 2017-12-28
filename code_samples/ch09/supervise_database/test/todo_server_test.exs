defmodule TodoServerTest do
  use ExUnit.Case, async: false

  setup do
    Todo.System.start_link()
    :ok
  end

  test "add_entry" do
    server = Todo.Cache.server_process("test_list_1")
    assert [] == Todo.Server.entries(server, ~D[2018-12-19])

    Todo.Server.add_entry(server, %{date: ~D[2018-12-19], title: "Dentist"})
    assert 1 == Enum.count(Todo.Server.entries(server, ~D[2018-12-19]))
    assert [%{title: "Dentist"}] = Todo.Server.entries(server, ~D[2018-12-19])
  end
end
