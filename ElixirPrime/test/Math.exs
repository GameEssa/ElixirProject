defmodule Math do
  @moduledoc """
    Math module is math algorithm
  """


  @doc """
    return sum a and b
  """
  @code1 10

  @code2 1
  def sum(a,b) do
    a + b
  end

  def code_sum do
    @code1 + @code2
  end

  def math_doc do
    @moduledoc
  end
end

IO.puts( Math.sum(1,5) )
