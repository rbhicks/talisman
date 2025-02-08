defmodule Athena.Mapper do
  use GenServer
  # fact templates can be added from the
  # rules, instead of a separate enumeration
  # because should a fact template not be
  # referenced by a rule, it's pointless
  # (should be pruned anyway)
  #  def add_rule_fact_templates ...
  #  def create_fact_template_to_rule_lhs_mapping ...

  def start(mapper_name) do
        GenServer.start_link(__MODULE__, [], name: {:global, mapper_name})
  end

  def init(_) do
    "asoetuhaosentuhaosnetuhaoesnuthaoestuhaosentuhaosnetuhaosnetuhasonetuhasoetuhaoeu" |> IO.puts
    "asoetuhaosentuhaosnetuhaoesnuthaoestuhaosentuhaosnetuhaosnetuhasonetuhasoetuhaoeu" |> IO.puts
    {
      :ok,
      {[], [], %{}}
    }
  end
end

