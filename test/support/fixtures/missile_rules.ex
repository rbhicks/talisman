# test missile rules
defmodule Athen.Test.Support.Fixtures.FoundIcbm do
  alias Athena.Rule
  alias Athena.Test.Support.Fixtures.MissileFactTemplate
  
  @behaviour Rule

  @lhs_fact_templates [MissileFactTemplate]

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

defmodule Athen.Test.Support.Fixtures.FoundMissileAndBombStrategicAttackVectors do
  alias Athena.Rule
  alias Athena.Test.Support.Fixtures.MissileFactTemplate
  alias Athena.Test.Support.Fixtures.BombFactTemplate
  
  @behaviour Rule

  @lhs_fact_templates [MissileFactTemplate, BombFactTemplate]

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
