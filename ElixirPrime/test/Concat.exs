defmodule Concat do

  def join( a , b \\ nil, sep \\ " " )

  def join( a, b, _sep ) when is_nil(b) do
    a
  end

  def join( a, b, sep) do
    a <> sep <> b
  end

  def joinon( a, b ) do
    IO.puts("First On")
    a <> b
  end

  def joinon( a, b, sep \\ " " )  do
    IO.puts("Second On")
    a <> sep <> b
  end

end
IO.puts Concat.joinon("Hello", "world")      #=> Hello world
IO.puts Concat.joinon("Hello", "world", "_") #=> Hello_world
