defmodule Athena.Mapper do
  use GenServer
  #  def create_fact_template_to_rule_lhs_mapping ...

  # fact templates can be added from the
  # rules, instead of a separate enumeration
  # because should a fact template not be
  # referenced by a rule, it's pointless
  # (should be pruned anyway)
  #
  # a batch version can be created later if needed
  def handle_call({:add_rule_fact_templates, rule_name, rule_fact_templates}, _from, state) do

    "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
    "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
    "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
    {:reply, :ok, %{rule_fact_templates: rule_fact_templates ++ {rule_name, rule_fact_templates}}}
  end
  
  def start() do
    GenServer.start_link(__MODULE__, %{rule_fact_templates: []})
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

