defmodule Athena.Rule do
  use GenServer

  def add_fact_id(fact_id) do
    {:ok}
  end
  
  def evaluate_lhs_for_fact_instances do
    {:ok, []}
  end
  
  def execute_rule do
    {:ok}
  end

  def start(rule_name, get_lhs_fact_templates_function, evaluate_lhs_function, execute_rule_function) do
    GenServer.start_link(__MODULE__, {get_lhs_fact_templates_function, evaluate_lhs_function, execute_rule_function}, name: {:global, rule_name})
  end

  def init({get_lhs_fact_templates_function, evaluate_lhs_function, execute_rule_function}) do
    {
      :ok,
      {
        # fact ids are the list at the end. init to empty. to be added by inference_engine
        get_lhs_fact_templates_function, evaluate_lhs_function, execute_rule_function, []
      }
    }
  end
end
