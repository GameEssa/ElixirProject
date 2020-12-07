defmodule KV.SupervisorETS do
  use Supervisor

  def start_link( opts ) do
    Supervisor.start_link( __MODULE__, :ok, opts )
  end

  def init( :ok ) do
    children = [
      { DynamicSupervisor , name: KV.BucketSupervisorETS, strategy: :one_for_one },
      { KV.RegistryETS, name: KV.RegistryETS}
    ]

    Supervisor.init( children, strategy: :one_for_all )
  end
end
