defmodule Todo.Application do
  use Application

  @impl Application
  def start(_, _) do
    Todo.System.start_link()
  end
end
