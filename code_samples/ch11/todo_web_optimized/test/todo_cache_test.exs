defmodule TodoCacheTest do
  use ExUnit.Case, async: false

  setup do
    :meck.new(Todo.Database, [:no_link])
    :meck.expect(Todo.Database, :start_link, fn -> nil end)
    :meck.expect(Todo.Database, :get, fn(_) -> nil end)
    :meck.expect(Todo.Database, :store, fn(_, _) -> :ok end)
    on_exit(fn ->
      :meck.unload(Todo.Database)
    end)
  end

  test "server_process" do
    Todo.ServerSupervisor.start_link
    Todo.Cache.start_link
    bobs_list = Todo.Cache.server_process("bobs_list")
    alices_list = Todo.Cache.server_process("alices_list")

    assert(bobs_list != alices_list)
    assert(bobs_list == Todo.Cache.server_process("bobs_list"))

    Process.exit(Process.whereis(:todo_server_supervisor), :normal)
  end
end