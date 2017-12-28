defmodule DatabaseTest do
  use ExUnit.Case, async: false

  setup do
    Todo.Database.start()
    on_exit(fn -> GenServer.stop(Todo.Database) end)
  end

  test "get and store" do
    assert(nil == Todo.Database.get(1))

    Todo.Database.store(1, {:some, "data"})
    Todo.Database.store(2, {:another, ["data"]})

    assert({:some, "data"} == Todo.Database.get(1))
    assert({:another, ["data"]} == Todo.Database.get(2))
  end
end
