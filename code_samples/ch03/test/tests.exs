Code.load_file("#{__DIR__}/../../test_helper.exs")

defmodule Test do
  use ExUnit.Case, async: false
  import TestHelper

  @test_file "#{__DIR__}/test_file"

  test_script "enum_streams_practice" do
    assert [3, 7, 11] == EnumStreams.lines_lengths!(@test_file)
    assert 11 == EnumStreams.longest_line_length!(@test_file)
    assert "foo bar baz" == EnumStreams.longest_line!(@test_file)
    assert [1, 2, 3] == EnumStreams.words_per_line!(@test_file)
  end

  test_script "geometry" do
    assert 6 == Geometry.area({:rectangle, 2, 3})
    assert 4 == Geometry.area({:square, 2})
    assert 3.14 == Geometry.area({:circle, 1})
    assert_raise FunctionClauseError, fn -> Geometry.area(:foo) end
  end

  test_script "geometry_invalid_input" do
    assert 6 == Geometry.area({:rectangle, 2, 3})
    assert 4 == Geometry.area({:square, 2})
    assert 3.14 == Geometry.area({:circle, 1})
    assert {:error, {:unknown_shape, :foo}} == Geometry.area(:foo)
  end

  test_script "natural_nums" do
    assert :ok == NaturalNums.print(3)
  end

  test_script "rect" do
    assert 6 == Rectangle.area({2, 3})
  end

  test_script "recursion_practice" do
    assert 0 == Loop.list_len([])
    assert 3 == Loop.list_len([1, 2, 3])

    assert [] == Loop.range(3, 2)
    assert [2, 3, 4] == Loop.range(2, 4)

    assert [] == Loop.positive([])
    assert [] == Loop.positive([-1, -2])
    assert [1, 3] == Loop.positive([1, -1, 0, 3])
  end

  test_script "recursion_practice_tc" do
    assert 0 == Loop.list_len([])
    assert 3 == Loop.list_len([1, 2, 3])

    assert [] == Loop.range(3, 2)
    assert [2, 3, 4] == Loop.range(2, 4)

    assert [] == Loop.positive([])
    assert [] == Loop.positive([-1, -2])
    assert [1, 3] == Loop.positive([1, -1, 0, 3])
  end

  test_script "sum_list" do
    assert 0 == ListHelper.sum([])
    assert 6 == ListHelper.sum([1, 2, 3])
  end

  test_script "sum_list_tc" do
    assert 0 == ListHelper.sum([])
    assert 6 == ListHelper.sum([1, 2, 3])
  end

  test_script "test_num" do
    assert :negative == TestNum.test(-1)
    assert :zero == TestNum.test(0)
    assert :positive == TestNum.test(1)
    assert :positive == TestNum.test(:foo)
  end

  test_script "test_num2" do
    assert :negative == TestNum.test(-1)
    assert :zero == TestNum.test(0)
    assert :positive == TestNum.test(1)
    assert_raise FunctionClauseError, fn -> TestNum.test(:foo) end
  end

  test_script "user_extraction" do
    assert {:error, "login missing"} == UserExtraction.extract_user(%{})
    assert {:error, "email missing"} == UserExtraction.extract_user(%{"login" => "a"})

    assert {:error, "password missing"} ==
             UserExtraction.extract_user(%{"login" => "a", "email" => "b"})

    assert {:ok, %{email: "b", login: "a", password: "c"}} ==
             UserExtraction.extract_user(%{"login" => "a", "email" => "b", "password" => "c"})
  end

  test_script "user_extraction_2" do
    assert {:error, "missing fields: login, email, password"} == UserExtraction.extract_user(%{})

    assert {:error, "missing fields: email, password"} ==
             UserExtraction.extract_user(%{"login" => "a"})

    assert {:error, "missing fields: password"} ==
             UserExtraction.extract_user(%{"login" => "a", "email" => "b"})

    assert {:ok, %{email: "b", login: "a", password: "c"}} ==
             UserExtraction.extract_user(%{"login" => "a", "email" => "b", "password" => "c"})
  end
end
