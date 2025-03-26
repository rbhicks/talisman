defmodule Talisman.Rule do
  use GenServer

  alias Talisman.Utilities

  def get_lhs_fact_template_names_hash(rule_pid) do
    {:ok, lhs_fact_template_names_hash} = GenServer.call(rule_pid, :get_lhs_fact_template_names_hash)
    lhs_fact_template_names_hash
  end
  
  def add_fact_id(fact_id) do
    {:ok}
  end
  
  def evaluate_lhs_for_fact_instances do
    {:ok, []}
  end
  
  def execute_rule do
    {:ok}
  end

  def handle_call(:get_lhs_fact_template_names_hash, _from, {lhs_fact_templates_hash, _, _, _, _} = state) do
    {
      :reply,
      {
        :ok,
        lhs_fact_templates_hash
      },
      state
    }
  end

  def start(rule_name, lhs_fact_template_names, evaluate_lhs_function, execute_rule_function) do
    GenServer.start_link(__MODULE__, {lhs_fact_template_names, evaluate_lhs_function, execute_rule_function}, name: {:global, rule_name})
  end

  def init({lhs_fact_template_names, evaluate_lhs_function, execute_rule_function}) do
    {
      :ok,
      {
        # fact ids are the list at the end. init to empty. to be added by inference_engine
        Utilities.generate_fact_template_names_hash(lhs_fact_template_names),
        lhs_fact_template_names,
        evaluate_lhs_function,
        execute_rule_function,
        []
      }
    }
  end
end
