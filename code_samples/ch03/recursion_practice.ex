defmodule Loop do
  def list_len([]), do: 0

  def list_len([_ | tail]) do
    1 + list_len(tail)
  end

  def range(from, to) when from > to do
    []
  end

  def range(from, to) do
    [from | range(from + 1, to)]
  end

  def positive([]), do: []

  def positive([head | tail]) when head > 0 do
    [head | positive(tail)]
  end

  def positive([_ | tail]) do
    positive(tail)
  end
end
