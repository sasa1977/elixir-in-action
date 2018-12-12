defmodule SimpleRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(key) do
    GenServer.call(__MODULE__, {:register, key, self()})
  end

  def whereis(key) do
    GenServer.call(__MODULE__, {:whereis, key})
  end

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:register, key, pid}, _, process_registry) do
    case Map.get(process_registry, key) do
      nil ->
        Process.link(pid)
        {:reply, :ok, Map.put(process_registry, key, pid)}

      _ ->
        {:reply, :error, process_registry}
    end
  end

  @impl GenServer
  def handle_call({:whereis, key}, _, process_registry) do
    {:reply, Map.get(process_registry, key), process_registry}
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _reason}, process_registry) do
    {:noreply, deregister_pid(process_registry, pid)}
  end

  defp deregister_pid(process_registry, pid) do
    # We'll walk through each {key, value} item, and keep those elements whose
    # value is different to the provided pid.
    process_registry
    |> Enum.reject(fn {_key, registered_process} -> registered_process == pid end)
    |> Enum.into(%{})
  end
end
