defmodule Athena.Mapper do
  use GenServer
  # fact templates can be added from the
  # rules, instead of a separate enumeration
  # because should a fact template not be
  # referenced by a rule, it's pointless
  # (should be pruned anyway)
  def add_rule_fact_templates(rule_fact_templates) do
    GenServer.call(self(), {:add_rule_fact_templates, rule_fact_templates})
  end
  #  def create_fact_template_to_rule_lhs_mapping ...

  def handle_call({:add_rule_fact_templates, rule_fact_templates}, _from, state) do
    nil
  end
  
  def start() do
    GenServer.start_link(__MODULE__, [])
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

