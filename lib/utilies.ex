defmodule Talisman.Utilities do
  def generate_fact_assertion_or_rule_addition_response(
        supervisor,
        child_spec,
        facts_or_rules,
        fact_or_rule_name,
        key,
        state
      ) do
    {_, pid} = DynamicSupervisor.start_child(supervisor, child_spec)

    updated_facts_or_rules = Map.put(facts_or_rules, child_spec.id, {fact_or_rule_name, pid})

    {
      :reply,
      {:ok, pid},
      state
      |> Map.put(key, updated_facts_or_rules)
    }
  end
end
