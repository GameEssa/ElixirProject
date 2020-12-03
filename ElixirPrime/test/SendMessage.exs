send(self(), {:key, "Name"})

receive do
  {:Key, value} ->
    IO.puts(value)
end
