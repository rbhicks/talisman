defmodule Athena.Rule do
  @callback add_fact_instance(%{:__struct__ => atom(), optional(atom()) => any()}) :: {:ok}
  @callback evaluate_lhs_for_instances :: {:ok, list(String.t)}
  @callback execute_rule :: {:ok}
end
