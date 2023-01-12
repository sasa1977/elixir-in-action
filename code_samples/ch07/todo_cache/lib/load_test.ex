# Very quick, inconclusive load test
#
# Start from command line with:
#   elixir --erl "+P 2000000" -S mix run -e LoadTest.run
#
# Note: the +P 2000000 sets maximum number of processes to 2 millions
defmodule LoadTest do
  def run do
    {:ok, cache} = Todo.Cache.start()

    total_processes = 1_000_000

    # Since the cache is empty, this code creates new processes.
    {put_time, _} =
      :timer.tc(fn ->
        Enum.each(
          1..total_processes,
          &Todo.Cache.server_process(cache, "cache_#{&1}")
        )
      end)

    IO.puts("average put #{put_time / total_processes} μs")

    # Since the cache is primed, and we use the same names as in the
    # previous loop, this code benches process retrieval.
    {get_time, _} =
      :timer.tc(fn ->
        Enum.each(
          1..total_processes,
          &Todo.Cache.server_process(cache, "cache_#{&1}")
        )
      end)

    IO.puts("average get #{get_time / total_processes} μs")
  end
end
