Code.load_file("#{__DIR__}/../../../test_helper.exs")

defmodule Test do
  use ExUnit.Case, async: false
  import TestHelper

  test_script "gen_server" do
    SimpleRegistry.start_link()
    assert SimpleRegistry.register("foo") == :ok
    assert SimpleRegistry.register("foo") == :error
    assert SimpleRegistry.whereis("foo") == self()
    assert SimpleRegistry.whereis("bar") == nil

    {:ok, pid} = Agent.start_link(fn -> SimpleRegistry.register("bar") end)
    assert SimpleRegistry.whereis("bar") == pid
    Agent.stop(pid)
    Process.sleep(100)
    assert SimpleRegistry.whereis("bar") == nil
  end

  test_script "ets" do
    SimpleRegistry.start_link()
    assert SimpleRegistry.register("foo") == :ok
    assert SimpleRegistry.register("foo") == :error
    assert SimpleRegistry.whereis("foo") == self()
    assert SimpleRegistry.whereis("bar") == nil

    {:ok, pid} = Agent.start_link(fn -> SimpleRegistry.register("bar") end)
    assert SimpleRegistry.whereis("bar") == pid
    Agent.stop(pid)
    Process.sleep(100)
    assert SimpleRegistry.whereis("bar") == nil
  end
end
