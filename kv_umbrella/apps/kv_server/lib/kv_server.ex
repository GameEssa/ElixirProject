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
    #Task.start_link( fn ->  client_loop( client ) end )
    {:ok, pid} = Task.Supervisor.start_child( KVServer.TaskSupervisor, fn -> client_loop( client ) end )
    :gen_tcp.controlling_process( client, pid )
    server_loop( socket )
  end

  defp client_loop( client ) do
    #client
    #|> read_line()
    msg =
      with {:ok, data} <- read_line( client ),
           {:ok, command} <- KVServer.Command.parse( data )
      do
        KVServer.Command.run( command )
      end

    write_line( client, msg )
    client_loop( client )
  end

  defp read_line( socket ) do
    :gen_tcp.recv( socket, 0 )
  end

  defp write_line( socket, {:ok, text} ) do
    :gen_tcp.send( socket, text )
  end

  defp write_line( socket, {:error, :unknown_command} ) do
    # Known error; write to the client
    :gen_tcp.send( socket, "UNKNOWN COMMAND\r\n" )
  end

  defp write_line( _socket, {:error, :closed} ) do
    # The connection was closed, exit politely
    exit( :shutdown )
  end

  defp write_line( socket, {:error, :not_found} ) do
    :gen_tcp.send( socket, "NOT FOUND\r\n" )
  end

  defp write_line( socket, {:error, error} ) do
    # Unknown error; write to the client and exit
    :gen_tcp.send( socket, "ERROR\r\n" )
    exit( error )
  end
end
