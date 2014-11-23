Code.load_file("#{__DIR__}/../../test_helper.exs")

defmodule Test do
  use ExUnit.Case, async: false
  import TestHelper

  @test_file "#{__DIR__}/test_file"

  test_script "calculator" do
    pid = Calculator.start
    Calculator.add(pid, 4)
    Calculator.mul(pid, 5)
    Calculator.sub(pid, 2)
    Calculator.div(pid, 2)

    assert 9 == Calculator.value(pid)
  end

  test_script "database_server" do
    pid = DatabaseServer.start
    DatabaseServer.run_async(pid, "foo")
    assert "foo result" == DatabaseServer.get_result
  end

  test_script "stateful_database_server" do
    pid = DatabaseServer.start
    DatabaseServer.run_async(pid, "foo")
    assert DatabaseServer.get_result =~ ~r/Connection \d{3}: foo result/
  end

  test_script "todo_server" do
    pid = TodoServer.start
    TodoServer.add_entry(pid, %{date: {2015, 1, 1}, title: "Dinner"})
    TodoServer.add_entry(pid, %{date: {2015, 1, 2}, title: "Dentist"})
    TodoServer.add_entry(pid, %{date: {2015, 1, 2}, title: "Meeting"})
    assert [%{date: {2015, 1, 1}, id: 1, title: "Dinner"}] == TodoServer.entries(pid, {2015, 1, 1})
  end

  test_script "registered_todo_server" do
    TodoServer.start
    :timer.sleep(200)
    TodoServer.add_entry(%{date: {2015, 1, 1}, title: "Dinner"})
    TodoServer.add_entry(%{date: {2015, 1, 2}, title: "Dentist"})
    TodoServer.add_entry(%{date: {2015, 1, 2}, title: "Meeting"})
    assert [%{date: {2015, 1, 1}, id: 1, title: "Dinner"}] == TodoServer.entries({2015, 1, 1})
  end

  test_script "process_bottleneck" do
    pid = Server.start
    assert :foo == Server.send_msg(pid, :foo)
  end
end