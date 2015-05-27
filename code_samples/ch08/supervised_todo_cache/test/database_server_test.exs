defmodule DatabaseServerTest do
  use ExUnit.Case, async: false

  setup do
    :meck.new(Todo.DatabaseWorker, [:no_link])
    :meck.expect(Todo.DatabaseWorker, :start, &MockTodo.DatabaseWorker.start/1)
    :meck.expect(Todo.DatabaseWorker, :store, &MockTodo.DatabaseWorker.store/3)
    :meck.expect(Todo.DatabaseWorker, :get, &MockTodo.DatabaseWorker.get/2)
    Todo.Database.start("./test_persist")

    on_exit(fn ->
      File.rm_rf("./test_persist/")
      send(:database_server, :stop)
      :meck.unload(Todo.DatabaseWorker)
    end)
  end

  test "pooling" do
    assert(Todo.Database.store(1, :a) == Todo.Database.store(1, :a))
    assert(Todo.Database.get(1) == Todo.Database.store(1, :a))
    assert(Todo.Database.store(2, :a) != Todo.Database.store(1, :a))
  end
end

defmodule MockTodo.DatabaseWorker do
  use GenServer

  def start(_) do
    GenServer.start(__MODULE__, nil)
  end

  def store(worker_pid, key, data) do
    GenServer.call(worker_pid, {:store, key, data})
  end

  def get(worker_pid, key) do
    GenServer.call(worker_pid, {:get, key})
  end


  def init(state) do
    {:ok, state}
  end

  def handle_call({:store, _, _}, _, state) do
    {:reply, self, state}
  end

  def handle_call({:get, _}, _, state) do
    {:reply, self, state}
  end

  # Needed for testing purposes
  def handle_info(:stop, state), do: {:stop, :normal, state}
  def handle_info(_, state), do: {:noreply, state}
end