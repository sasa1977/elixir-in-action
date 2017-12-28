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
    {_results, bad_nodes} =
      :rpc.multicall(
        __MODULE__,
        :store_local,
        [key, data],
        :timer.seconds(5)
      )

    Enum.each(bad_nodes, &IO.puts("Store failed on node #{&1}"))
    :ok
  end

  def store_local(key, data) do
    :poolboy.transaction(__MODULE__, &Todo.DatabaseWorker.store(&1, key, data))
  end

  def get(key) do
    :poolboy.transaction(__MODULE__, &Todo.DatabaseWorker.get(&1, key))
  end

  defp db_folder() do
    # Node name is used to determine the database folder. This allows us to
    # start multiple nodes from the same folders, and data will not clash.
    [name_prefix, _] = "#{node()}" |> String.split("@")
    "#{Application.fetch_env!(:todo, :db_folder)}/#{name_prefix}/"
  end
end
