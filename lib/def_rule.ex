defmodule DefRule do

  def crack_fact_template_names({_, _, [{_, _, [[]|_]}|_]}), do: []
  def crack_fact_template_names({_, _, [{_, _, [fact_template_names|_]}|_]}) do
    
    fact_template_names
  end

  def crack_lhs_evaluation_and_rhs_execution_bodies({_, _, [{_, _, [_|[{_, _, [lhs_evaluation_body|rhs_execution_body]}|_]]}|_]}) do
    {lhs_evaluation_body, rhs_execution_body}
  end

  defmacro def_rule(rule_name, rule) do

    fact_template_names = crack_fact_template_names(rule)
    {lhs_evaluation_body, rhs_execution_body} = crack_lhs_evaluation_and_rhs_execution_bodies(rule)

    "asnoetuhasoentuhasoentuh" |> IO.puts()
    "asnoetuhasoentuhasoentuh" |> IO.puts()
    "asnoetuhasoentuhasoentuh" |> IO.puts()
    rule_name |> IO.inspect(limit: :infinity)
    "=================================" |> IO.puts()
    fact_template_names|> IO.inspect(limit: :infinity)
    "=================================" |> IO.puts()
    "48573495873459873459348"  |> IO.puts()
    "48573495873459873459348"  |> IO.puts()
    "48573495873459873459348"  |> IO.puts()

    quote do
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      # unquote(rule_name |> IO.inspect(limit: :infinity))
      # unquote("=================================" |> IO.puts())
      # unquote(fact_template_names|> IO.inspect(limit: :infinity))
      # unquote("=================================" |> IO.puts())
      unquote(lhs_evaluation_body |> IO.inspect(limit: :infinity))
      unquote("=================================" |> IO.puts())
      unquote(rhs_execution_body |> IO.inspect(limit: :infinity))
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
    end
  end
end

# fn %MissileFactTemplate{} = missile, %PropulsionFactTemplate{} = propulsion ->

#         Rules.add_rule(rules, :found_icbm, %{
#               lhs_fact_template_names: [MissileFactTemplate],
#               lhs_fact_multiplicity: %{MissileFactTemplate => 1},
#               evaluate_lhs_function: fn
#                 ^missile, ^propulsion = propulsion when propulsion == :jet -> true
#                 _, _ -> false
#               end,
#               execute_rule_function: fn -> {missile, propulsion} end
#         })
# end
