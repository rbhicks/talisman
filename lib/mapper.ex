defmodule Athena.Mapper do
  use GenServer
  # fact templates can be added from the
  # rules, instead of a separate enumeration
  # because should a fact template not be
  # referenced by a rule, it's pointless
  # (should be pruned anyway)
  #
  # a batch version can be created later if needed
  def add_rule_fact_templates(server, rule_name, rule_fact_templates) do
    GenServer.call(server, {:add_rule_fact_templates, rule_name, rule_fact_templates})
  end
  #  def create_fact_template_to_rule_lhs_mapping ...

  def handle_call(
    {:add_rule_fact_templates, rule_name, rule_fact_templates},
    _from,
    %{
      fact_templates: current_fact_templates,
      rule_fact_templates: current_rule_fact_templates
    }
  ) do
    {
      :reply,
      :ok,
      %{
        fact_templates: current_fact_templates
        |> MapSet.to_list()
        |> Enum.concat(rule_fact_templates)
        |> MapSet.new(),
        rule_fact_templates: current_rule_fact_templates ++ {rule_name, rule_fact_templates}
      }
    }
  end
  
  def start() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    "asoetuhaosentuhaosnetuhaoesnuthaoestuhaosentuhaosnetuhaosnetuhasonetuhasoetuhaoeu" |> IO.puts
    "asoetuhaosentuhaosnetuhaoesnuthaoestuhaosentuhaosnetuhaosnetuhasonetuhasoetuhaoeu" |> IO.puts
    {
      :ok,
       %{fact_templates: MapSet.new(), rule_fact_templates: []}
    }
  end
end

