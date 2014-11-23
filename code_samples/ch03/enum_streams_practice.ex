defmodule EnumStreams do
  defp filtered_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  def lines_lengths!(path) do
    filtered_lines!(path)
    |> Enum.map(&String.length/1)
  end

  def longest_line_length!(path) do
    filtered_lines!(path)
    |> Stream.map(&String.length/1)
    |> Enum.reduce(0, &max/2)
  end


  def longest_line!(path) do
    filtered_lines!(path)
    |> Enum.reduce("", &longer_line/2)
  end

  defp longer_line(line1, line2) do
    if String.length(line1) > String.length(line2) do
      line1
    else
      line2
    end
  end


  def words_per_line!(path) do
    filtered_lines!(path)
    |> Enum.map(&word_count/1)
  end

  defp word_count(string) do
    string
    |> String.split(" ")
    |> length
  end
end