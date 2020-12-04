defmodule SampleTest do
  use ExUnit.Case
  doctest Sample

  test "greets the world" do
    assert Sample.hello() == :world
    assert Sample.hello() == :hello
  end
end
