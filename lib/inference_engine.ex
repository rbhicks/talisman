defmodule Talisman.InferenceEngine do

  def create_fact_rule_lhs_cartesian_product([]), do: [[]]
  
  def create_fact_rule_lhs_cartesian_product(facts) do
    facts
    |> Enum.reduce([[]], fn current_fact_list, acc ->
      for x <- acc, y <- current_fact_list do
        [y | x]
      end
    end)
    |> Enum.map(&Enum.reverse/1)
  end

#  def load ...
#  def reset ...
#  def run ...

#  defp add_activated_rule ...
#  defp resolve_execution_order ...
end
