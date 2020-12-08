defmodule KV.Bucket do
  use Agent, restart: :temporary

  @moduledoc """
    This a Bucket to store key value
  """

  @doc "initial bucket"
  def start_link( _opts ) do
    Agent.start_link(fn -> %{} end )
  end

  def put( bucket, key, value ) do
    Agent.update( bucket,
      fn map -> Map.put( map, key, value ) end )
  end

  def get( bucket, key ) do
    Agent.get( bucket,
      fn map -> Map.get( map, key ) end )
  end


  def delete( bucket, key ) do
    Agent.get_and_update( bucket,
      fn map -> Map.pop( map ,key ) end )
  end

end
