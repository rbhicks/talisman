defmodule DefRule do

  def crack_fact_template_names({_, _, [{_, _, [[]|_]}|_]}), do: []
  def crack_fact_template_names({_, _, [{_, _, [fact_template_names|_]}|_]}), do: fact_template_names

  # def crack_lhs_evaluation_and_rhs_execution_bodies({_, _, [{_, _, lhs_evaluation_and_rhs_execution_bodies}|_]}) do
  def crack_lhs_evaluation_and_rhs_execution_bodies({_, _, [{_, _, lhs_evaluation_and_rhs_execution_bodies}|_]}) do
    lhs_evaluation_and_rhs_execution_bodies
  end

  defmacro def_rule(rule_name, rule) do
    quote do
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      unquote(rule_name |> IO.inspect(limit: :infinity))
      unquote("=================================" |> IO.puts())
      unquote(rule |> IO.inspect(limit: :infinity))
      unquote("=================================" |> IO.puts())
      unquote(rule |> crack_fact_template_names() |> IO.inspect(limit: :infinity))
      unquote("=================================" |> IO.puts())
      unquote(rule |> crack_lhs_evaluation_and_rhs_execution_bodies() |> IO.inspect(limit: :infinity))
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
    end
  end
end
