defmodule KVServer do
  require Logger

  def accept( port ) do
    {:ok, socket} =
      :gen_tcp.listen( port, [:binary, packet: :line, active: false, reuseaddr: true] )
    Logger.info( "Listen Port #{port}" )
    server_loop( socket )
  end


  defp server_loop( socket ) do
    {:ok, client} = :gen_tcp.accept( socket )
    client_loop(client)
    server_loop( socket )
  end

  defp client_loop( client ) do
    client
    |> read_line()
    |> write_line(client)

    client_loop(client)
  end

  defp read_line( socket ) do
    {:ok, data} = :gen_tcp.recv( socket, 0 )
    data
  end

  defp write_line( line, socket ) do
    :gen_tcp.send( socket, line )
  end

end
