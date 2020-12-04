defmodule Executable.CLI do
  def main(arg \\ []) do
    IO.puts "Execute File, running"
    arg
    |> parse_args()
    |> response()
    |> IO.puts()
  end

  defp parse_args(args) do
    {opts, word, _} =
      args
      |> OptionParser.parse(switches: [upcase: :boolean])

    {opts, List.to_string(word)}
  end

  defp response({opts, word}) do
    if opts[:upcase], do: String.upcase(word), else: word
  end
end

defmodule Example do
  def explode, do: raise("Error") #exit(:kaboom)

  def run do
    Process.flag(:trap_exit, true)
    try do
      spawn_link(Example, :explode, [])
    catch
      {:EXIT, _from_pid, reason} -> IO.puts("Exit reason: #{reason}")
    end
  end
end
