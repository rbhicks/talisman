defmodule Talisman do
  @moduledoc """
  Documentation for `Talisman`.
  """

  alias Talisman.TalismanDynamicSupervisor
  
  def start(_type, _args) do
    
    children = [
      Talisman.TalismanDynamicSupervisor,
      {Registry, keys: :unique, name: Talisman.Registry}
    ]
    
    {:ok, supervisor_id} = Supervisor.start_link(children, strategy: :one_for_one)


    facts_supervisor_child_spec =
      %{
        id: :facts_supervisor,
        start: {
          DynamicSupervisor,
          :start_link,
          [[name: :facts_supervisor]]
        }
      }

    rules_supervisor_child_spec =
      %{
        id: :rules_supervisor,
        start: {
          DynamicSupervisor,
          :start_link,
          [[name: :rules_supervisor]]
        }
      }

    {:ok, facts_supervisor_pid} = TalismanDynamicSupervisor.start_talisman_genserver(facts_supervisor_child_spec)
    {:ok, rules_supervisor_pid} = TalismanDynamicSupervisor.start_talisman_genserver(rules_supervisor_child_spec)

    {:ok, _} = Registry.register(Talisman.Registry, :facts_supervisor, facts_supervisor_pid)
    {:ok, _} = Registry.register(Talisman.Registry, :rules_supervisor, rules_supervisor_pid)
    
    "dijfd83gi156niost84s7xokwuu9d7" |> IO.puts
    "dijfd83gi156niost84s7xokwuu9d7" |> IO.puts
    "dijfd83gi156niost84s7xokwuu9d7" |> IO.puts
    Supervisor.which_children(supervisor_id) |> IO.inspect(limit: :infinity)
    "==============================" |> IO.puts
    facts_supervisor_pid |> IO.inspect(limit: :infinity)
    "==============================" |> IO.puts
    rules_supervisor_pid |> IO.inspect(limit: :infinity)
    "==============================" |> IO.puts
    Registry.lookup(Talisman.Registry, :facts_supervisor) |> IO.inspect(limit: :infinity)
    "==============================" |> IO.puts
    Registry.lookup(Talisman.Registry, :rules_supervisor) |> IO.inspect(limit: :infinity)
    "9grcvmtv8d0b2xklwzbqaamtl02lr5" |> IO.puts
    "9grcvmtv8d0b2xklwzbqaamtl02lr5" |> IO.puts
    "9grcvmtv8d0b2xklwzbqaamtl02lr5" |> IO.puts

    {:ok, supervisor_id}
  end
end
