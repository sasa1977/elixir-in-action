defmodule Todo.PoolSupervisor do
  use Supervisor

  def start_link(pool_size) do
    Supervisor.start_link(__MODULE__, pool_size)
  end

  def init(pool_size) do
    processes = for worker_id <- 1..pool_size do
      worker(
        Todo.DatabaseWorker, [worker_id],
        id: {:database_worker, worker_id}
      )
    end

    supervise(processes, strategy: :one_for_one)
  end
end