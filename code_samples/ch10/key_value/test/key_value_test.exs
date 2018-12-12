defmodule KeyValueTest do
  use ExUnit.Case

  test "key value" do
    KeyValue.start_link()
    KeyValue.put(:foo, 1)
    KeyValue.put(:bar, 2)

    assert KeyValue.get(:foo) == 1
    assert KeyValue.get(:bar) == 2
  end

  test "ets key value" do
    EtsKeyValue.start_link()
    EtsKeyValue.put(:foo, 1)
    EtsKeyValue.put(:bar, 2)

    assert EtsKeyValue.get(:foo) == 1
    assert EtsKeyValue.get(:bar) == 2
  end
end
