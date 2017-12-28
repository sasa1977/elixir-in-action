defmodule Todo.Database do
  def start_link do
    File.mkdir_p!(db_folder())

    :poolboy.start_link(
      [
        name: {:local, __MODULE__},
        worker_module: Todo.DatabaseWorker,
        size: 3
      ],
      [db_folder()]
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
    :poolboy.transaction(__MODULE__, &Todo.DatabaseWorker.store(&1, key, data))
  end

  def get(key) do
    :poolboy.transaction(__MODULE__, &Todo.DatabaseWorker.get(&1, key))
  end

  defp db_folder() do
    Application.fetch_env!(:todo, :db_folder)
  end
end
