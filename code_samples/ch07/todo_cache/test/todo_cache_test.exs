defmodule TodoCacheTest do
  use ExUnit.Case, async: true

  test "server_process" do
    {:ok, cache} = Todo.Cache.start
    bobs_list = Todo.Cache.server_process(cache, "bobs_list")
    alices_list = Todo.Cache.server_process(cache, "alices_list")

    assert(bobs_list != alices_list)
    assert(bobs_list == Todo.Cache.server_process(cache, "bobs_list"))
  end
end