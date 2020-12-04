defmodule SampleQueue do
  use GenServer

  def handle_cast({:enqueue, value}, state) do
    {:noreply, state ++ [value]}
  end

  def handle_call(:dequeue, _form, [value | state]) do
    {:reply, value, state}
  end

  def handle_call(:dequeue, _form, []) do
    {:reply, nil, []}
  end

  def handle_call(:queue, _form, state) do
    {:reply, state, state}
  end


  def queue do
    GenServer.call(__MODULE__, :queue)
  end

  def dequeue do
    GenServer.call(__MODULE__, :dequeue)
  end

  def enqueue(value) do
    GenServer.cast(__MODULE__, {:enqueue, value})
  end

  @doc """
    Current Process is linked to GenServer, and Agent a List state
  """
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
    SampleQueue GenServer Init function
   """
  def init(state) do
    {:ok, state}
  end
end
