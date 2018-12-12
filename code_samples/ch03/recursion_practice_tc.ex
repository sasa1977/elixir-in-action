defmodule Loop do
  def list_len(list), do: calc_list_len(list, 0)

  defp calc_list_len([], len), do: len

  defp calc_list_len([_ | tail], len) do
    calc_list_len(tail, len + 1)
  end

  # This solution collects backwards, starting with the `to` and going
  # back to from. This allows us to make a single pass collection and
  # still retain tail-recursive property. See the second clause of
  # `make_range/3` for explanation.
  #
  # Thanks to the anonymous poster for pointing this out to me
  # at the book's forum (https://forums.manning.com/posts/list/36894.page)
  def range(from, to) do
    make_range(from, to, [])
  end

  # At this point we have the result
  defp make_range(from, to, result) when from > to do
    result
  end

  defp make_range(from, to, result) do
    # - We first prepend `to` to the top of the accumulated list.
    # - Then, we just loop the recursion with decremented `to`.
    # - Since this is the last thing done in the function, it's a tail-recursive
    #   call.
    # - Since we continuously prepend decrementing `to`s to the result, we'll
    #   get the result in the proper order.
    make_range(from, to - 1, [to | result])
  end

  def positive(list) do
    filter_positive(list, [])
  end

  defp filter_positive([], result) do
    # Here we can't do the trick as with `range/2` above, since we
    # can only traverse the list forward from the head to the tail.
    # Thus, when we collect the result, it will be reversed (see the second
    # clause of `filter_positive/2`). So we need to do one final reversal of
    # the result to get it in the proper order.
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
