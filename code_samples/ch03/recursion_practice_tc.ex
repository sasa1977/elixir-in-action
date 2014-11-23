defmodule Loop do
  def list_len(list), do: calc_list_len(list, 0)

  defp calc_list_len([], len), do: len
  defp calc_list_len([_ | tail], len) do
    calc_list_len(tail, len + 1)
  end
  


  def range(from, to) do
    make_range(from, to, [])
  end

  defp make_range(from, to, result) when from > to do
    # The accumulation has built the result in the inverse order
    # so we have to reverse it.
    Enum.reverse(result)
  end

  defp make_range(from, to, result) do
    # Notice how we push from to the top of the new result. This
    # is a very fast operation, but it makes the result in the
    # inverse order. Therefore, at the end of the iteration, we will have
    # to reverse the result (see above).
    #
    # This is an example of a case where tail recursive approach is slower,
    # since it takes another pass over the entire list to reverse the result.
    make_range(from + 1, to, [from | result])
  end



  def positive(list) do
    filter_positive(list, [])
  end

  defp filter_positive([], result) do
    # Again, we have to reverse the result
    Enum.reverse(result)
  end

  defp filter_positive([head | tail], result) when head > 0 do
    # Pushing to the head of the result builds the result in the inverse order.
    filter_positive(tail, [head | result])
  end

  defp filter_positive([_ | tail], result) do
    filter_positive(tail, result)
  end
end