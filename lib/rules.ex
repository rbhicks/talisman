defmodule Talisman.Rules do
  alias Talisman.Rule
  
  def get_rules(server) do
    {:ok, rules} = GenServer.call(server, :get_rules)
    rules
  end
  
  def add_rule(server, rule_name, rule) do
    GenServer.call(server, {:add_rule, rule_name, rule})
    
  end

  def handle_call({:add_rule, rule_name, rule}, _from, %{rules_supervisor: rules_supervisor, rules: rules} = state) do

    updated_rules = %{
      id: rule_name,
      start: {
        Rule,
        :start,
        [
          rule_name,
          rule.get_lhs_fact_templates_function,
          rule.evaluate_lhs_function,
          rule.execute_rule_function
        ]
      }
    }
    |> then(fn rule_child_spec -> DynamicSupervisor.start_child(rules_supervisor, rule_child_spec) end)
    |> then(fn {_, rule_pid} -> Map.put(rules, rule_name, {rule_name, rule_pid}) end)
    
    {
      :reply,
      :ok,
      state
      |> Map.put(:rules, updated_rules)
    }
  end

  def handle_call(:get_rules, _from, %{rules: rules} = state) do
    {
      :reply,
      {:ok, rules},
      state
    }
  end

  def start([rules_supervisor]) do
    GenServer.start_link(__MODULE__, rules_supervisor)
  end
  
  def init({_, rules_supervisor}) do
    {
      :ok,
       %{
         rules_supervisor: rules_supervisor,
         rules: %{}
       }
    }
  end
end
