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

  def create_cartesian_product([]), do: [[]]

  def create_cartesian_product(elements) do
    elements
    |> Enum.reduce([[]], fn current_element, acc ->
      for x <- acc, y <- current_element do
        [y | x]
      end
    end)
    |> Enum.map(&Enum.reverse/1)
    # get rid of degenerate cases (i.e., the same fact instance
    # used more than once)
    |> Enum.filter(fn cartesian_product_element ->
      cartesian_product_element
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.reduce_while(false, fn value, acc ->
        if value == 1 do
          {:cont, true}
        else
          {:halt, false}
        end
      end)
    end)
  end
end
