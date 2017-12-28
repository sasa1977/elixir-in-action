defmodule Todo.Database do
  @pool_size 3

  @db_folder "./persist"

  def start_link do
    File.mkdir_p!(@db_folder)

    Supervisor.start_link(
      Enum.map(1..@pool_size, &{Todo.DatabaseWorker, {@db_folder, &1}}),
      strategy: :one_for_one
    )
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end
end
