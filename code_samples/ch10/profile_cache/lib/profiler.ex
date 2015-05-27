# Simple benchmark helper which relies on :timer.tc/1
defmodule Profiler do
  def run(module, operations_count, concurrency_level \\ 1) do
    IO.puts ""

    module.start_link

    time = execution_time(
      fn -> module.cached(:index, &WebServer.index/0) end,
      operations_count,
      concurrency_level
    )

    projected_rate = round(1000000 * operations_count * concurrency_level / time)
    IO.puts "#{projected_rate} reqs/sec\n"
  end

  defp execution_time(fun, operations_count, concurrency_level) do
    # We measure the execution time of the entire operation
    {time, _} = :timer.tc(fn ->
      me = self

      # Spawn client processes
      for _ <- 1..concurrency_level do
        spawn(fn ->
          # Execute the function in the client process
          for _ <- 1..operations_count, do: fun.()

          # Notify the master process that we've done
          send(me, :computed)
        end)
      end

      # In the master process, we await all :computed messages from all processes.
      for _ <- 1..concurrency_level do
        receive do
          :computed -> :ok
        end
      end
    end)

    time # [microseconds]
  end
end