Code.load_file("#{__DIR__}/../../test_helper.exs")

defmodule Test do
  use ExUnit.Case, async: false
  import TestHelper

  @test_file "#{__DIR__}/test_file"

  test_script "key_value_gen_server" do
    {:ok, pid} = KeyValueStore.start()
    KeyValueStore.put(pid, :a, 1)
    KeyValueStore.put(pid, :b, 2)
    assert KeyValueStore.get(pid, :a) == 1
    assert KeyValueStore.get(pid, :b) == 2
    assert KeyValueStore.get(pid, :c) == nil
  end

  test_script "server_process" do
    pid = KeyValueStore.start()
    KeyValueStore.put(pid, :a, 1)
    KeyValueStore.put(pid, :b, 2)
    assert KeyValueStore.get(pid, :a) == 1
    assert KeyValueStore.get(pid, :b) == 2
    assert KeyValueStore.get(pid, :c) == nil
  end

  test_script "server_process_cast" do
    pid = KeyValueStore.start()
    KeyValueStore.put(pid, :a, 1)
    KeyValueStore.put(pid, :b, 2)
    assert KeyValueStore.get(pid, :a) == 1
    assert KeyValueStore.get(pid, :b) == 2
    assert KeyValueStore.get(pid, :c) == nil
  end

  test_script "server_process_todo" do
    pid = TodoServer.start()
    TodoServer.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.add_entry(pid, %{date: ~D[2018-01-02], title: "Dentist"})
    TodoServer.add_entry(pid, %{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] ==
             TodoServer.entries(pid, ~D[2018-01-01])
  end

  test_script "todo_server" do
    {:ok, pid} = TodoServer.start()
    TodoServer.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.add_entry(pid, %{date: ~D[2018-01-02], title: "Dentist"})
    TodoServer.add_entry(pid, %{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] ==
             TodoServer.entries(pid, ~D[2018-01-01])
  end
end
