defmodule KV.Registry do
  use GenServer
  def init( :ok ) do
    refs = %{}
    names = %{}
    {:ok, {names, refs}}
  end

  def handle_call( {:lookup, key}, _form, state ) do
    {names, _} = state
    {:reply, Map.fetch( names, key ), state}
  end

  def handle_cast( {:create, key}, {names, refs} ) do
    if ( Map.has_key?( names, key ) ) do
      {:onreply, {names, refs}}
    else
      {:ok, pid} = DynamicSupervisor.start_child( KV.BucketSupervisor, KV.Bucket )
      ref = Process.monitor( pid )
      refs = Map.put( refs, ref , key )
      names = Map.put( names, key, pid )
      {:noreply, {names, refs}}
    end
  end

  def handle_info( {:DOWN, ref, :process, _pid, _reason}, {names, refs} ) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end


  def start_link( opts ) do
    GenServer.start_link( __MODULE__, :ok, opts)
  end

  def lookup( registry, key ) do
    GenServer.call( registry, {:lookup, key} )
  end

  def create( registry, key ) do
    GenServer.cast( registry, {:create, key} )
  end

  def info( _msg, state ) do
     inspect state
  end
end
