defmodule DatabaseWorkerTest do
  use ExUnit.Case, async: false

  setup do
    {:ok, worker} = Todo.DatabaseWorker.start_link("./test_persist", 1)

    on_exit(fn ->
      File.rm_rf("./test_persist/")
      send(worker, :stop)
    end)

    {:ok, worker: worker}
  end

  test "get and store" do
    assert(nil == Todo.DatabaseWorker.get(1, 1))

    Todo.DatabaseWorker.store(1, 1, {:some, "data"})
    Todo.DatabaseWorker.store(1, 2, {:another, ["data"]})

    assert({:some, "data"} == Todo.DatabaseWorker.get(1, 1))
    assert({:another, ["data"]} == Todo.DatabaseWorker.get(1, 2))
  end
end