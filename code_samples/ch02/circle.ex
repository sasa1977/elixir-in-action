defmodule Circle do
  @moduledoc "Implements basic circle functions"
  @pi 3.14159

  @doc "Computes the area of a circle"
  @spec area(number) :: number
  def area(r), do: r*r*@pi

  @doc "Computes the circumference of a circle"
  @spec circumference(number) :: number
  
  def circumference(r), do: 2*r*@pi
end
