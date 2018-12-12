defmodule Bench do
  @total_keys 1_000_000

  def run(module, opts \\ []) do
    IO.puts("")

    concurrency = min(Keyword.get(opts, :concurrency, 1), @total_keys)
    num_updates = Keyword.get(opts, :num_updates, 10)
    items_per_process = div(@total_keys, concurrency)

    module.start_link()

    {time, _} =
      :timer.tc(fn ->
        0..(concurrency - 1)
        |> Enum.map(
          &start_load_process(module, &1 * items_per_process, items_per_process, num_updates)
        )
        |> Enum.map(&Task.await(&1, :infinity))
      end)

    throughput = round(1_000_000 * items_per_process * num_updates * concurrency * 2 / time)
    IO.puts("#{throughput} operations/sec\n")
  end

  defp start_load_process(module, start_item, items_per_process, num_updates) do
    # Tasks are not explained in the book, but the basic usage is very simple.
    # A combination of Task.async + Task.await is a simple wrapper around spawning a process which sends the result back.
    # For more details refer to https://hexdocs.pm/elixir/Task.html.
    Task.async(fn ->
      perform_updates(module, start_item, start_item + items_per_process, num_updates)
    end)
  end

  # Note: we're not using Enum, Stream, or for comprehension here, to improve the running time, and avoid
  # skew in the result. Instead, this double loop is implemented with two recursions.

  defp perform_updates(_module, _start_item, _end_item, 0), do: :ok

  defp perform_updates(module, start_item, end_item, value) do
    update_items(module, start_item, end_item, value)
    perform_updates(module, start_item, end_item, value - 1)
  end

  defp update_items(_module, end_item, end_item, _value), do: :ok

  defp update_items(module, start_item, end_item, value) do
    module.put(start_item, value)
    module.get(start_item)
    update_items(module, start_item + 1, end_item, value)
  end
end
