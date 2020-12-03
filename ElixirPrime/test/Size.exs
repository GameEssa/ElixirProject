
  defprotocol Size do
    @fallback_to_any
    def size(data)
  end

  defimpl Size, for: BitString  do
    def size(data), do: String.length(data)
  end

  defimpl Size, for: Map  do
    def size(data), do: Kernel.map_size(data)
  end

  defimpl Size, for: Tuple do
    def size(data), do: Kernel.tuple_size(data)
  end

  defimpl Size, for: MapSet  do
    def size(set), do: MapSet.size(set)
  end

  defimpl Size, for: Any  do
    def size(_), do: 0
  end

  IO.puts Size.size("foo")
  IO.puts Size.size({:ok, "hello"})
  IO.puts Size.size(%{label: "some label"})
