defmodule SimpleRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(key) do
    # We're linking to the registry server first, to avoid possible race condition.Note that it's therefore possible
    # that a caller process is linked, even though the registration fails. We can't simply unlink on a failing
    # registration, since a process might be registered under some other term. To properly solve this, we'd need another
    # ETS table to keep track of whether a process is already registered under some other term. To keep things simple,
    # this is not done here. For a proper implementation, you can study the Registry code at
    # https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/registry.ex
    Process.link(Process.whereis(__MODULE__))

    if :ets.insert_new(__MODULE__, {key, self()}) do
      :ok
    else
      :error
    end
  end

  def whereis(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, pid}] -> pid
      [] -> nil
    end
  end

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    :ets.new(__MODULE__, [:named_table, :public, read_concurrency: true, write_concurrency: true])
    {:ok, nil}
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _reason}, state) do
    :ets.match_delete(__MODULE__, {:_, pid})
    {:noreply, state}
  end
end
