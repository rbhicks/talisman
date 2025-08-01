defmodule Talisman.Rules do
  use GenServer

  alias Talisman.Rule
  alias Talisman.Utilities

  def set_rules_supervisor(server, rules_supervisor) do
    GenServer.call(server, {:set_rules_supervisor, rules_supervisor})
  end
  
  def set_inference_engine(server, inference_engine) do
    GenServer.call(server, {:set_inference_engine, inference_engine})
  end

  def get_rules(server) do
    {:ok, rules} = GenServer.call(server, :get_rules)
    rules
  end

  def add_rule(server, rule_name, rule) do
    GenServer.call(server, {:add_rule, rule_name, rule})
  end

    def handle_call({:set_rules_supervisor, rules_supervisor}, _, state) do
    {
      :reply,
      :ok,
      state
      |> Map.put(:rules_supervisor, rules_supervisor)
    }
  end
  
  def handle_call({:set_inference_engine, inference_engine}, _, state) do
    {
      :reply,
      :ok,
      state
      |> Map.put(:inference_engine, inference_engine)
    }
  end
    
  def handle_call(
        {:add_rule, rule_name, rule},
        _from,
        %{rules_supervisor: rules_supervisor, rules: rules} = state
      ) do
    Utilities.generate_fact_assertion_or_rule_addition_response(
      rules_supervisor,
      %{
        id: rule_name,
        start: {
          Rule,
          :start,
          [
            rule_name,
            rule.lhs_fact_template_names,
            rule.lhs_fact_multiplicity,
            # rule.evaluate_lhs_function_args,
            # rule.evaluate_lhs_function,
            # rule.execute_rule_function
            rule.get_rule_lhs_evaluation_and_rhs_execution_functions
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

  def start() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {
      :ok,
      %{
        rules_supervisor: nil,
        inference_engine: nil,
        rules: %{}
      }
    }
  end
end
