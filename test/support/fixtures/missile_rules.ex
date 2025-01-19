# test missile rules
defmodule Athen.Test.Support.Fixtures.FoundIcbm do
  def get_lhs_fact_templates, do: [MissileFactTemplate]
    
  def evaluate_lhs(fact_instances) do
    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
    get_lhs_fact_templates() |> IO.inspect(limit: :infinity)
    "===================================" |> IO.puts
    fact_instances |> IO.inspect(limit: :infinity)
    "+++++++++++++++++++++++++++++++++++" |> IO.puts
    "+++++++++++++++++++++++++++++++++++" |> IO.puts
    "+++++++++++++++++++++++++++++++++++" |> IO.puts
    {:ok}
  end
  
  def execute_rhs do 
    "()()()()()()()()()()()()()()()()()()" |> IO.puts
    "fox-1" |> IO.puts
    "()()()()()()()()()()()()()()()()()()" |> IO.puts
  end  
end

# defmodule Athen.Test.Support.Fixtures.FoundMissileAndBombStrategicAttackVectors do
#   alias Athena.Rule
#   alias Athena.Test.Support.Fixtures.MissileFactTemplate
#   alias Athena.Test.Support.Fixtures.BombFactTemplate
  
#   @behaviour Rule

#   @lhs_fact_templates [MissileFactTemplate, BombFactTemplate]

#   @impl Rule
#   def add_fact_instance(fact_instance) do
#     {:ok}
#   end

#   @impl Rule
#   def evaluate_lhs_for_instances do
#     {:ok, []}
#   end

#   @impl Rule
#   def execute_rule do
#     {:ok}
#   end
# end
