defmodule SampleQueue.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    childern = [
      {SampleQueue, [1, 2, 3, 4]}
    ]
    Supervisor.init(childern, strategy: :one_for_one)
  end
end
