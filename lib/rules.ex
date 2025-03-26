defmodule Talisman.Rules do
  alias Talisman.Rule
  alias Talisman.Utilities
  
  def get_rules(server) do
    {:ok, rules} = GenServer.call(server, :get_rules)
    rules
  end
  
  def add_rule(server, rule_name, rule) do
    GenServer.call(server, {:add_rule, rule_name, rule})
    
  end

  def handle_call({:add_rule, rule_name, rule}, _from, %{rules_supervisor: rules_supervisor, rules: rules} = state) do

    Utilities.generate_fact_assertion_or_rule_addition_response(
      rules_supervisor,
      %{
        id: rule_name,
        start: {
          Rule,
          :start,
          [
            rule_name,
            rule.lhs_fact_templates,
            rule.evaluate_lhs_function,
            rule.execute_rule_function
          ]
        }
      },
      rules,
      rule_name,
      :rules,
      state
    )    
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
