defmodule Todo.ProcessRegistry do
  def start_link do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def via(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  def whereis(key) do
    case Registry.lookup(__MODULE__, key) do
      [{pid, _value}] -> pid
      [] -> nil
    end
  end

  def child_spec(_arg) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end
end
