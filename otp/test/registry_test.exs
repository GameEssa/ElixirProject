defmodule RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(BucketRegistry)
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert BucketRegistry.lookup(registry, "shopping") == :error

    BucketRegistry.create(registry, "shopping")
    assert {:ok, bucket} = BucketRegistry.lookup(registry, "shopping")

    Bucket.put(bucket, "milk", 1)
    assert Bucket.get(bucket, "milk") == 1

    Agent.stop(bucket)
    #assert {:ok, bucket} = BucketRegistry.lookup(registry, "shopping")
    BucketRegistry.create(registry, "shopping")
    assert {:ok, bucket} = BucketRegistry.lookup(registry, "shopping")
  end
end
