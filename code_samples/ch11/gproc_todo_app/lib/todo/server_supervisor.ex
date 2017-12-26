defmodule Todo.ServerSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: :todo_server_supervisor)
  end

  def start_child(todo_list_name) do
    Supervisor.start_child(:todo_server_supervisor, [todo_list_name])
  end

  def init(_) do
    supervise([worker(Todo.Server, [])], strategy: :simple_one_for_one)
  end
end
