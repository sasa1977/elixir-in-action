defmodule Todo.Cache do
  def server_process(todo_list_name) do
    existing_process(todo_list_name) || ensure_server_started(todo_list_name)
  end

  defp existing_process(todo_list_name) do
    case Todo.Server.whereis(todo_list_name) do
      :undefined -> nil
      pid -> pid
    end
  end

  defp ensure_server_started(todo_list_name) do
    case Todo.ServerSupervisor.start_child(todo_list_name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end
end
