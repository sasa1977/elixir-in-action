defmodule TodoListTest do
  use ExUnit.Case, async: true

  test "empty list" do
    assert Todo.List.size(Todo.List.new()) == 0
  end

  test "entries" do
    todo_list =
      Todo.List.new([
        %{date: ~D[2018-12-19], title: "Dentist"},
        %{date: ~D[2018-12-20], title: "Shopping"},
        %{date: ~D[2018-12-19], title: "Movies"}
      ])

    assert Todo.List.size(todo_list) == 3
    assert todo_list |> Todo.List.entries(~D[2018-12-19]) |> length() == 2
    assert todo_list |> Todo.List.entries(~D[2018-12-20]) |> length() == 1
    assert todo_list |> Todo.List.entries(~D[2018-12-21]) |> length() == 0

    titles = todo_list |> Todo.List.entries(~D[2018-12-19]) |> Enum.map(& &1.title)
    assert ["Dentist", "Movies"] = titles
  end

  test "add_entry" do
    todo_list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})
      |> Todo.List.add_entry(%{date: ~D[2018-12-20], title: "Shopping"})
      |> Todo.List.add_entry(%{date: ~D[2018-12-19], title: "Movies"})

    assert Todo.List.size(todo_list) == 3
    assert todo_list |> Todo.List.entries(~D[2018-12-19]) |> length() == 2
    assert todo_list |> Todo.List.entries(~D[2018-12-20]) |> length() == 1
    assert todo_list |> Todo.List.entries(~D[2018-12-21]) |> length() == 0

    titles = todo_list |> Todo.List.entries(~D[2018-12-19]) |> Enum.map(& &1.title)
    assert ["Dentist", "Movies"] = titles
  end

  test "update_entry" do
    todo_list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})
      |> Todo.List.add_entry(%{date: ~D[2018-12-20], title: "Shopping"})
      |> Todo.List.add_entry(%{date: ~D[2018-12-19], title: "Movies"})
      |> Todo.List.update_entry(2, &Map.put(&1, :title, "Updated shopping"))

    assert Todo.List.size(todo_list) == 3
    assert [%{title: "Updated shopping"}] = Todo.List.entries(todo_list, ~D[2018-12-20])
  end

  test "delete_entry" do
    todo_list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})
      |> Todo.List.add_entry(%{date: ~D[2018-12-20], title: "Shopping"})
      |> Todo.List.add_entry(%{date: ~D[2018-12-19], title: "Movies"})
      |> Todo.List.delete_entry(2)

    assert Todo.List.size(todo_list) == 2
    assert Todo.List.entries(todo_list, ~D[2018-12-20]) == []
  end
end
