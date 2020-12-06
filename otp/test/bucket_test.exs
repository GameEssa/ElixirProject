defmodule BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = Bucket.start_link([])
    %{bucket: bucket}
  end

  test "stores values by key" , %{bucket: bucket} do
  #  {:ok, bucket} = start_supervised Bucket

    assert Bucket.get(bucket, "milk") == nil

    Bucket.put(bucket, "milk", 3)
    assert Bucket.get(bucket, "milk") == 3
  end
end
