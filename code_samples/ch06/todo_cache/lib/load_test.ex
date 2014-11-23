# Very quick, inconclusive load test
# Start from command line with:
#   iex --erl '+P 2000000' -S mix run -e LoadTest.run
# Note: the +P 2000000 sets maximum number of processes to 2 millions
defmodule LoadTest do
  @size 1_000_000
  @interval 100_000

  def run do
    {:ok, cache} = Todo.Cache.start

    0..(round(@size/@interval) - 1)
    |> Enum.each(&run_interval(cache, &1 * @interval))
  end

  defp run_interval(cache, start) do
    {time, _} = :timer.tc(fn ->
      start..(start + @interval - 1)
      |> Enum.each(&Todo.Cache.server_process(cache, "cache_#{&1}"))
    end)
    IO.puts "#{start + @interval} put #{time/@interval} μs"

    {time, _} = :timer.tc(fn ->
      start..(start + @interval)
      |> Enum.each(&Todo.Cache.server_process(cache, "cache_#{&1}"))
    end)
    IO.puts "#{start + @interval} get #{time/@interval} μs\n"
  end
end