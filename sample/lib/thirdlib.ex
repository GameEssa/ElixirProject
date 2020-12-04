defmodule Thirdlib do
  @moduledoc """
    This modeule aims to use Erlang library
    :timer.tc
  """

  def timed(func, args) do
    {time, result} = :timer.tc(func, args)
    IO.puts "Time: #{time} us"
    IO.puts "Result: #{result}"
  end

  def word_count(args) do
    :string.words(to_charlist(args) )
  end
end
