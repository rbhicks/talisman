defmodule DefRuleFunction do


  # defmacro def_rule_function(lhs, rhs) do
  defmacro def_rule_function(y) do
    quote do
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      # unquote(lhs |> IO.inspect(limit: :infinity))
      # unquote("=====================================" |> IO.puts)
      # unquote(rhs |> IO.inspect(limit: :infinity))
      unquote(y |> IO.inspect(limit: :infinity))
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
    end
  end
end
