defmodule Talisman.Utilities do

  def generate_powerset([head | tail]) do
    tail_set = generate_powerset(tail)
    with_head = Enum.map(tail_set, &[head | &1])
    [[head] | tail_set ++ with_head]
  end
  def generate_powerset([]), do: []
  
  def generate_fact_template_names_hash(fact_template_names) do
    fact_template_names
    |> Enum.sort()
    |> Enum.reduce("", fn template_name_atom, acc -> acc <> Atom.to_string(template_name_atom) end )
    |> then(fn template_names -> :crypto.hash(:sha256, template_names) end)
    |> Base.encode16()
  end

  def generate_fact_assertion_or_rule_addition_response(supervisor, child_spec, facts_or_rules, fact_or_rule_name,  update_key, state) do

    updated_facts_or_rules =
    child_spec
    |> then(fn child_spec -> DynamicSupervisor.start_child(supervisor, child_spec) end)
    |> then(fn {_, pid} -> Map.put(facts_or_rules, fact_or_rule_name, {fact_or_rule_name, pid}) end)
    
    {
      :reply,
      :ok,
      state
      |> Map.put(update_key, updated_facts_or_rules)
    }
  end
end
