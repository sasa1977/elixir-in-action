defmodule TestNum do
  def test(x) when is_number(x) and x < 0 do
    :negative
  end

  def test(x) when x == 0 do
    :zero
  end

  def test(x) when is_number(x) and x > 0 do
    :positive
  end
end
