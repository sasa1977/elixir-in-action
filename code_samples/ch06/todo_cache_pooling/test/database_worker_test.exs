defmodule DatabaseWorkerTest do
  use ExUnit.Case, async: false

  setup do
    {:ok, worker} = Todo.DatabaseWorker.start("./test_persist")

    on_exit(fn ->
      File.rm_rf("./test_persist/")
      send(worker, :stop)
    end)

    {:ok, worker: worker}
  end

  test "get and store", context do
    assert(nil == Todo.DatabaseWorker.get(context[:worker], 1))

    Todo.DatabaseWorker.store(context[:worker], 1, {:some, "data"})
    Todo.DatabaseWorker.store(context[:worker], 2, {:another, ["data"]})

    assert({:some, "data"} == Todo.DatabaseWorker.get(context[:worker], 1))
    assert({:another, ["data"]} == Todo.DatabaseWorker.get(context[:worker], 2))
  end
end