defmodule TodoListTest do
  use ExUnit.Case, async: true

  test "add_entry" do
    assert(3 == sample_todo_list.size)
    assert(2 == sample_todo_list |> Todo.List.entries({2013, 12, 19}) |> length)
    assert(1 == sample_todo_list |> Todo.List.entries({2013, 12, 20}) |> length)
    assert(nil == sample_todo_list |> Todo.List.entries({2013, 12, 22}))

    assert({2013, 12, 20} == shopping_entry.date)
    assert("Shopping" == shopping_entry.title)
  end

  defp sample_todo_list do
    Todo.List.new
    |> Todo.List.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})
    |> Todo.List.add_entry(%{date: {2013, 12, 20}, title: "Shopping"})
    |> Todo.List.add_entry(%{date: {2013, 12, 19}, title: "Movies"})
  end

  defp shopping_entry(todo_list \\ sample_todo_list) do
    todo_list
    |> Todo.List.entries({2013, 12, 20})
    |> Enum.at(0)
  end
end