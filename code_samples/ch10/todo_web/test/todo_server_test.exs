defmodule TodoServerTest do
  use ExUnit.Case, async: false

  setup do
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

  test "update_entry", context do
    Todo.Server.add_entry(context[:todo_server], %{date: {2013, 12, 19}, title: "Dentist"})
    Todo.Server.update_entry(context[:todo_server], 1, &Map.put(&1, :title, "Updated dentist"))
    assert("Updated dentist" == (Todo.Server.entries(context[:todo_server], {2013, 12, 19}) |> Enum.at(0)).title)
  end

  test "delete_entry", context do
    Todo.Server.add_entry(context[:todo_server], %{date: {2013, 12, 19}, title: "Dentist"})
    Todo.Server.delete_entry(context[:todo_server], 1)
    assert([] == Todo.Server.entries(context[:todo_server], {2013, 12, 19}))
  end
end