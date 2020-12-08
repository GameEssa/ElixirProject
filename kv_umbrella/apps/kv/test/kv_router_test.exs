defmodule KV.RouterTest do
  use ExUnit.Case

  @tag :distributed
  test "route requests across nodes" do
    assert KV.Router.route( "hello", Kernel, :node, [] ) ==
      :"foo@DESKTOP-D3S6F5E"
    assert KV.Router.route( "world", Kernel, :node, [] ) ==
      :"boo@DESKTOP-D3S6F5E"
  end

  @tag :distributed
  test "raises on unknown entries" do
    assert_raise RuntimeError,  ~r/could not find entry/, fn ->
      KV.Router.route( <<0>>, Kernel, :node, [] )
    end
  end
end
