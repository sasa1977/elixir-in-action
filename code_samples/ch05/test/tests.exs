Code.load_file("#{__DIR__}/../../test_helper.exs")

defmodule Test do
  use ExUnit.Case, async: false
  import TestHelper

  @test_file "#{__DIR__}/test_file"

  test_script "calculator" do
    pid = Calculator.start()
    Calculator.add(pid, 4)
    Calculator.mul(pid, 5)
    Calculator.sub(pid, 2)
    Calculator.div(pid, 2)

    assert 9 == Calculator.value(pid)
  end

  test_script "database_server" do
    pid = DatabaseServer.start()
    DatabaseServer.run_async(pid, "foo")
    assert "foo result" == DatabaseServer.get_result()
  end

  test_script "stateful_database_server" do
    pid = DatabaseServer.start()
    DatabaseServer.run_async(pid, "foo")
    assert DatabaseServer.get_result() =~ ~r/Connection \d+: foo result/
  end

  test_script "todo_server" do
    pid = TodoServer.start()
    TodoServer.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.add_entry(pid, %{date: ~D[2018-01-02], title: "Dentist"})
    TodoServer.add_entry(pid, %{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] ==
             TodoServer.entries(pid, ~D[2018-01-01])
  end

  test_script "registered_todo_server" do
    TodoServer.start()
    Process.sleep(200)
    TodoServer.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})
    TodoServer.add_entry(%{date: ~D[2018-01-02], title: "Meeting"})
    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] == TodoServer.entries(~D[2018-01-01])
  end

  test_script "process_bottleneck" do
    pid = Server.start()
    assert :foo == Server.send_msg(pid, :foo)
  end
end
