Code.load_file("#{__DIR__}/../../test_helper.exs")

defmodule Test do
  use ExUnit.Case, async: false
  import TestHelper

  @test_file "#{__DIR__}/test_file"

  test_script "fraction" do
    assert 0.5 = Fraction.new(1,2) |> Fraction.value
    assert 0.75 = Fraction.new(1,2) |> Fraction.add(Fraction.new(1, 4)) |> Fraction.value
  end

  test_script "simple_todo" do
    list =
      TodoList.new
      |> TodoList.add_entry({2015, 1, 1}, "Dinner")
      |> TodoList.add_entry({2015, 1, 2}, "Dentist")

    assert ["Dinner"] == TodoList.entries(list, {2015, 1, 1})
    assert [] == TodoList.entries(list, {2015, 1, 3})
  end

  test_script "todo_multi_dict" do
    list =
      TodoList.new
      |> TodoList.add_entry({2015, 1, 1}, "Dinner")
      |> TodoList.add_entry({2015, 1, 2}, "Dentist")
      |> TodoList.add_entry({2015, 1, 2}, "Meeting")

    assert ["Meeting", "Dentist"] == TodoList.entries(list, {2015, 1, 2})
    assert [] == TodoList.entries(list, {2015, 1, 3})
  end

  test_script "todo_entry_map" do
    list =
      TodoList.new
      |> TodoList.add_entry(%{date: {2015, 1, 1}, title: "Dinner"})
      |> TodoList.add_entry(%{date: {2015, 1, 2}, title: "Dentist"})
      |> TodoList.add_entry(%{date: {2015, 1, 2}, title: "Meeting"})

    assert [%{date: {2015, 1, 1}, title: "Dinner"}] == TodoList.entries(list, {2015, 1, 1})
    assert [] == TodoList.entries(list, {2015, 1, 3})
  end

  test_script "todo_crud" do
    list =
      TodoList.new
      |> TodoList.add_entry(%{date: {2015, 1, 1}, title: "Dinner"})
      |> TodoList.add_entry(%{date: {2015, 1, 2}, title: "Dentist"})
      |> TodoList.add_entry(%{date: {2015, 1, 2}, title: "Meeting"})

    assert [%{date: {2015, 1, 1}, id: 1, title: "Updated"}] ==
      list
      |> TodoList.update_entry(1, fn(entry) -> %{entry | title: "Updated"} end)
      |> TodoList.entries({2015, 1, 1})

    assert [] ==
      list
      |> TodoList.delete_entry(1)
      |> TodoList.entries({2015, 1, 1})
  end

  test_script "todo_builder" do
    list = TodoList.new([
      %{date: {2015, 1, 1}, title: "Dinner"},
      %{date: {2015, 1, 2}, title: "Dentist"},
      %{date: {2015, 1, 2}, title: "Meeting"}
    ])
    assert [%{date: {2015, 1, 1}, id: 1, title: "Dinner"}] == TodoList.entries(list, {2015, 1, 1})
    assert [] == TodoList.entries(list, {2015, 1, 3})
  end

  test_script "todo_import" do
    list = TodoList.CsvImporter.import("#{__DIR__}/../todos.csv")
    assert [%{date: {2013, 12, 20}, id: 2, title: "Shopping"}] == TodoList.entries(list, {2013, 12, 20})
  end
end