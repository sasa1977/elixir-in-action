defmodule TodoCacheTest do
  use ExUnit.Case, async: false

  setup do
    Todo.System.start_link()
    :ok
  end

  test "server_process" do
    bobs_list = Todo.Cache.server_process("bobs_list")
    alices_list = Todo.Cache.server_process("alices_list")

    assert(bobs_list != alices_list)
    assert(bobs_list == Todo.Cache.server_process("bobs_list"))
  end
end
