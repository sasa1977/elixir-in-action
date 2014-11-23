defmodule Todo.Server do
  use GenServer

  def start_link(name) do
    IO.puts "Starting to-do server for #{name}"
    GenServer.start_link(
      Todo.Server, name,
      name: {:global, {:todo_server, name}}
    )
  end

  def add_entry(todo_server, new_entry) do
    # add_entry is turned into a call
    GenServer.call(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end

  def update_entry(todo_server, entry_id, updater_fun) do
    GenServer.cast(todo_server, {:update_entry, entry_id, updater_fun})
  end

  def delete_entry(todo_server, entry_id) do
    GenServer.cast(todo_server, {:delete_entry, entry_id})
  end

  def whereis(name) do
    :global.whereis_name({:todo_server, name})
  end


  def init(name) do
    {:ok, {name, Todo.Database.get(name) || Todo.List.new}}
  end


  def handle_cast({:update_entry, entry_id, updater_fun}, {name, todo_list}) do
    {:noreply, {name, Todo.List.update_entry(todo_list, entry_id, updater_fun)}}
  end

  def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do
    {:noreply, {name, Todo.List.delete_entry(todo_list, entry_id)}}
  end


  def handle_call({:add_entry, new_entry}, _, {name, todo_list}) do
    todo_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, todo_list)
    {:reply, :ok, {name, todo_list}}
  end

  def handle_call({:entries, date}, _, {name, todo_list}) do
    {
      :reply,
      Todo.List.entries(todo_list, date),
      {name, todo_list}
    }
  end

  # Needed for testing purposes
  def handle_info(:stop, state), do: {:stop, :normal, state}
  def handle_info(_, state), do: {:noreply, state}
end