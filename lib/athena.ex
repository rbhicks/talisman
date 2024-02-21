defmodule Athena do
  @moduledoc """
  Documentation for `Athena`.
  """

  def start(_type, _args) do

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" |> IO.puts
    "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" |> IO.puts
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" |> IO.puts
    
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
