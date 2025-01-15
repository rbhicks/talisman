# test missile rules
defmodule Athen.Test.Support.Fixtures.FoundIcbm do
  alias Athena.Rule
  
  @behaviour Rule

  @lhs_fact_templates [Athena.Test.Support.Fixtures.MissileFactTemplate]

  @impl Rule
  def add_fact_instance(fact_instance) do
    {:ok}
  end

  @impl Rule
  def evaluate_lhs_for_instances do
    {:ok, []}
  end

  @impl Rule
  def execute_rule do
    {:ok}
  end
end
