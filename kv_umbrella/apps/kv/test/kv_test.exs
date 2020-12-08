defmodule KVTest do
  use ExUnit.Case
  doctest KV

  test "greets the world" do
    assert KV.hello() == :world
  end


  setup context do
    _ = start_supervised!({KV.RegistryETS, name: context.test})
    %{registry: context.test}
  end

  test "spawns buckets", %{registry: registry} do
    assert KV.RegistryETS.lookup(registry, "shopping") == :error

    KV.RegistryETS.create(registry, "shopping")
    assert {:ok, bucket} = KV.RegistryETS.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.RegistryETS.create(registry, "shopping")
    {:ok, bucket} = KV.RegistryETS.lookup(registry, "shopping")
    Agent.stop(bucket)

    # Do a call to ensure the registry processed the DOWN message
    _ = KV.RegistryETS.create(registry, "bogus")
    assert KV.RegistryETS.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    KV.RegistryETS.create(registry, "shopping")
    {:ok, bucket} = KV.RegistryETS.lookup(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)

    # Do a call to ensure the registry processed the DOWN message
    _ = KV.RegistryETS.create(registry, "bogus")
    assert KV.RegistryETS.lookup(registry, "shopping") == :error
  end

end
