defmodule TodoServerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, todo_server} = Todo.Server.start()
    on_exit(fn -> GenServer.stop(todo_server) end)
    {:ok, todo_server: todo_server}
  end

  test "add_entry", context do
    assert([] == Todo.Server.entries(context[:todo_server], ~D[2018-12-19]))

    Todo.Server.add_entry(context[:todo_server], %{date: ~D[2018-12-19], title: "Dentist"})
    assert(1 == Todo.Server.entries(context[:todo_server], ~D[2018-12-19]) |> length)

    assert(
      "Dentist" ==
        (Todo.Server.entries(context[:todo_server], ~D[2018-12-19]) |> Enum.at(0)).title
    )
  end
end
