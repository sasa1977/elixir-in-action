defmodule EnumStreams do
  defp filtered_lines!(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  def lines_lengths!(path) do
    path
    |> filtered_lines!()
    |> Enum.map(&String.length/1)
  end

  def longest_line_length!(path) do
    path
    |> filtered_lines!()
    |> Stream.map(&String.length/1)
    |> Enum.max()
  end

  def longest_line!(path) do
    path
    |> filtered_lines!()
    |> Enum.max_by(&String.length/1)
  end

  def words_per_line!(path) do
    path
    |> filtered_lines!()
    |> Enum.map(&word_count/1)
  end

  defp word_count(string) do
    string
    |> String.split()
    |> length()
  end
end
