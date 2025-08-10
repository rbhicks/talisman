defmodule Talisman.TalismanDynamicSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_talisman_genserver(talisman_genserver_child_spec) do
    DynamicSupervisor.start_child(__MODULE__, talisman_genserver_child_spec)
  end
end
