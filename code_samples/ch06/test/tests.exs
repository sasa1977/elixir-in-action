Code.load_file("#{__DIR__}/../../test_helper.exs")

defmodule Test do
  use ExUnit.Case, async: false
  import TestHelper

  @test_file "#{__DIR__}/test_file"

  test_script "todo_server" do
    {:ok, pid} = TodoServer.start
    TodoServer.add_entry(pid, %{date: {2015, 1, 1}, title: "Dinner"})
    TodoServer.add_entry(pid, %{date: {2015, 1, 2}, title: "Dentist"})
    TodoServer.add_entry(pid, %{date: {2015, 1, 2}, title: "Meeting"})
    assert [%{date: {2015, 1, 1}, id: 1, title: "Dinner"}] == TodoServer.entries(pid, {2015, 1, 1})
  end

  test_script "singleton_todo_server" do
    {:ok, _} = TodoServer.start
    TodoServer.add_entry(%{date: {2015, 1, 1}, title: "Dinner"})
    TodoServer.add_entry(%{date: {2015, 1, 2}, title: "Dentist"})
    TodoServer.add_entry(%{date: {2015, 1, 2}, title: "Meeting"})
    assert [%{date: {2015, 1, 1}, id: 1, title: "Dinner"}] == TodoServer.entries({2015, 1, 1})
  end

  test_script "full_todo_server" do
    {:ok, pid} = TodoServer.start
    TodoServer.add_entry(pid, %{date: {2015, 1, 1}, title: "Dinner"})
    TodoServer.add_entry(pid, %{date: {2015, 1, 2}, title: "Dentist"})
    TodoServer.add_entry(pid, %{date: {2015, 1, 2}, title: "Meeting"})

    TodoServer.update_entry(pid, 1, fn(entry) -> %{entry | title: "Updated"} end)
    assert [%{date: {2015, 1, 1}, id: 1, title: "Updated"}] == TodoServer.entries(pid, {2015, 1, 1})

    TodoServer.delete_entry(pid, 1)
    assert [] == TodoServer.entries(pid, {2015, 1, 1})
  end
end