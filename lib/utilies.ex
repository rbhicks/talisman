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

  # since the get rid of degenerate cartesian cases by
  # dedup'ing then filtering if the list length is 1,
  # we need to capture actual single element lists above,
  # i.e., here.
  def create_cartesian_product([_|[]] = single_element_list), do: single_element_list
  
  def create_cartesian_product(elements) do
    elements
    |> Enum.reduce([[]], fn current_element, acc ->
      for x <- acc, y <- current_element do
        [y | x]
      end
    end)
    |> Enum.map(&Enum.reverse/1)
    # get rid of results where all the elements are the same
    # (a degenerate case)
    |> Enum.filter(fn cartesian_product ->
      cartesian_product
      |> Enum.dedup()
      |> Enum.count()
      |> Kernel.!=(1)
    end)
  end
end
