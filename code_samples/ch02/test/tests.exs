Code.load_file("#{__DIR__}/../../test_helper.exs")

defmodule Test do
  use ExUnit.Case, async: false
  import TestHelper

  test_script "private_fun" do
    assert 4 == TestPrivate.double(2)
  end

  test_script "arity_calc" do
    assert 1 == Calculator.sum(1)
    assert 3 == Calculator.sum(1, 2)
  end

  test_script "arity_demo" do
    assert 4 == Rectangle.area(2)
    assert 6 == Rectangle.area(2, 3)
  end

  test_script "geometry" do
    assert 6 == Geometry.rectangle_area(3, 2)
  end
end
