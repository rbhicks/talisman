defmodule Talisman.Rule do
  use GenServer

  def get_lhs_fact_templates_hash(rule_pid) do
    {:ok, lhs_fact_templates_hash} = GenServer.call(rule_pid, :get_lhs_fact_templates_hash)
    lhs_fact_templates_hash
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

  def handle_call(:get_lhs_fact_templates_hash, _from, {lhs_fact_templates_hash, _, _, _, _} = state) do
    {
      :reply,
      {
        :ok,
        lhs_fact_templates_hash
      },
      state
    }
  end

  def start(rule_name, lhs_fact_templates, evaluate_lhs_function, execute_rule_function) do
    GenServer.start_link(__MODULE__, {lhs_fact_templates, evaluate_lhs_function, execute_rule_function}, name: {:global, rule_name})
  end

  def init({lhs_fact_templates, evaluate_lhs_function, execute_rule_function}) do
    {
      :ok,
      {
        # fact ids are the list at the end. init to empty. to be added by inference_engine
        lhs_fact_templates
        |> Enum.sort()
        |> Enum.reduce("", fn template_name_atom, acc -> acc <> Atom.to_string(template_name_atom) end )
        |> then(fn template_names -> :crypto.hash(:sha256, template_names) end)
        |> Base.encode16(),
        lhs_fact_templates,
        evaluate_lhs_function,
        execute_rule_function,
        []
      }
    }
  end
end
