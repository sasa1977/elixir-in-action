defmodule CacheTest do
  use ExUnit.Case

  test "page cache" do
    {:ok, _} = PageCache.start_link
    assert :foo == PageCache.cached(:index, fn -> :foo end)
    assert :foo == PageCache.cached(:index, fn -> :bar end)
  end

  test "ets page cache" do
    {:ok, _} = EtsPageCache.start_link
    assert :foo == EtsPageCache.cached(:index, fn -> :foo end)
    assert :foo == EtsPageCache.cached(:index, fn -> :bar end)
  end
end
