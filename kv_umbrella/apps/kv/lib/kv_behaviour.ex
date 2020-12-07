defmodule KV.Worker do
  @callback init( state ::map() ) :: {:ok, new_state ::map()} | {:error, reason :: String.t()}
end

defmodule KV.WorkerImpl do
  @behaviour KV.Worker

  def init( state ) do
    {:ok , state}
  end
end
