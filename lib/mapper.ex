defmodule Athena.Mapper do
  use GenServer
  # fact templates can be added from the
  # rules, instead of a separate enumeration
  # because should a fact template not be
  # referenced by a rule, it's pointless
  # (should be pruned anyway)
  def add_rule_fact_template(rule_fact_template) do
    GenServer.call(self(), {:add_rule_fact_template, rule_fact_template})
  end
  #  def create_fact_template_to_rule_lhs_mapping ...

  def handle_call({:add_rule_fact_template, rule_fact_template}, _from, state) do
    # the rule_fact_templates will be a list of tuples: {rule_name, fact_templates}
    # so they can be processed individually. if needed, a batch version can also be
    # added
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

