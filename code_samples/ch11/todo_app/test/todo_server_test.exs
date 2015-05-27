defmodule TodoServerTest do
  use ExUnit.Case, async: false

  setup do
    Todo.ProcessRegistry.start_link
    :meck.new(Todo.Database, [:no_link])
    :meck.expect(Todo.Database, :get, fn(_) -> nil end)
    :meck.expect(Todo.Database, :store, fn(_, _) -> :ok end)

    {:ok, todo_server} = Todo.Server.start_link("test_list")

    on_exit(fn ->
      :meck.unload(Todo.Database)
      send(todo_server, :stop)
    end)

    {:ok, todo_server: todo_server}
  end


  test "add_entry", context do
    assert([] == Todo.Server.entries(context[:todo_server], {2013, 12, 19}))

    Todo.Server.add_entry(context[:todo_server], %{date: {2013, 12, 19}, title: "Dentist"})
    assert(1 == Todo.Server.entries(context[:todo_server], {2013, 12, 19}) |> length)
    assert("Dentist" == (Todo.Server.entries(context[:todo_server], {2013, 12, 19}) |> Enum.at(0)).title)
  end
end