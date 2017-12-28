defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [
        Todo.ProcessRegistry,
        Todo.Database,
        Todo.Cache
      ],
      name: __MODULE__,
      strategy: :one_for_one
    )
  end
end
