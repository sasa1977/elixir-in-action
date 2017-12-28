defmodule TodoServerTest do
  use ExUnit.Case, async: false

  setup do
    Todo.Database.start()

    on_exit(fn -> GenServer.stop(Todo.Database) end)
  end

  test "add_entry" do
    {:ok, todo_server} = Todo.Server.start("test_list")

    assert([] == Todo.Server.entries(todo_server, ~D[2018-12-19]))

    Todo.Server.add_entry(todo_server, %{date: ~D[2018-12-19], title: "Dentist"})
    assert(1 == Todo.Server.entries(todo_server, ~D[2018-12-19]) |> length)

    assert(
      "Dentist" ==
        (Todo.Server.entries(todo_server, ~D[2018-12-19]) |> Enum.at(0)).title
    )
  end
end
