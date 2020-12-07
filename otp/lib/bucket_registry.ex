defmodule BucketRegistry do
  use GenServer

  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  def handle_call( {:lookup, name}, _form, state ) do
    {names, _} = state
    {:reply, Map.fetch(names, name), state}
  end

  def handle_cast( {:create, name}, {names, refs} ) do
    if ( Map.has_key?( names, name) ) do
      {:onreply, {names, refs}}
    else
      #{:ok, bucket} = Bucket.start_link([])
      {:ok, pid} = DynamicSupervisor.start_child( BucketDynamicSupervisor, Bucket )
      ref = Process.monitor( pid )
      refs = Map.put( refs, ref , name )
      names = Map.put( names, name, pid )
      {:noreply, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end


  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def lookup(server, name) do
    GenServer.call( server, {:lookup, name} )
  end

  def create(server, name) do
    GenServer.cast( server, {:create, name} )
  end

end
