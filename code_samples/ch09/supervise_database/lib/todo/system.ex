defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [
        Todo.Database,
        Todo.Cache
      ],
      strategy: :one_for_one
    )
  end
end
