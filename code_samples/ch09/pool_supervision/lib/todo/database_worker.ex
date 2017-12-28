defmodule Todo.DatabaseWorker do
  use GenServer

  def start_link({db_folder, worker_id}) do
    IO.puts("Starting database worker #{worker_id}")

    GenServer.start_link(
      __MODULE__,
      db_folder,
      name: registered_name(worker_id)
    )
  end

  def child_spec({db_folder, worker_id}) do
    %{
      id: {__MODULE__, worker_id},
      start: {__MODULE__, :start_link, [{db_folder, worker_id}]},
      type: :worker
    }
  end

  def store(worker_id, key, data) do
    GenServer.cast(registered_name(worker_id), {:store, key, data})
  end

  def get(worker_id, key) do
    GenServer.call(registered_name(worker_id), {:get, key})
  end

  defp registered_name(worker_id) do
    Todo.ProcessRegistry.via({__MODULE__, worker_id})
  end

  @impl GenServer
  def init(db_folder) do
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    db_folder
    |> file_name(key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  @impl GenServer
  def handle_call({:get, key}, _, db_folder) do
    data =
      case File.read(file_name(db_folder, key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    {:reply, data, db_folder}
  end

  defp file_name(db_folder, key) do
    Path.join(db_folder, to_string(key))
  end
end
