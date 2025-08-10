defmodule Talisman do
  @moduledoc """
  Documentation for `Talisman`.
  """

  def start(_type, _args) do
    
    children = [
      Talisman.TalismanDynamicSupervisor,
      {Registry, keys: :unique, name: Talisman.Registry}
    ]
    
    {:ok, supervisor_id} = Supervisor.start_link(children, strategy: :one_for_one)

    "dijfd83gi156niost84s7xokwuu9d7" |> IO.puts
    "dijfd83gi156niost84s7xokwuu9d7" |> IO.puts
    "dijfd83gi156niost84s7xokwuu9d7" |> IO.puts
    supervisor_id |> IO.inspect(limit: :infinity)
    "==============================" |> IO.puts
    Supervisor.which_children(supervisor_id) |> IO.inspect(limit: :infinity)
    "9grcvmtv8d0b2xklwzbqaamtl02lr5" |> IO.puts
    "9grcvmtv8d0b2xklwzbqaamtl02lr5" |> IO.puts
    "9grcvmtv8d0b2xklwzbqaamtl02lr5" |> IO.puts

    {:ok, supervisor_id}
  end
end
