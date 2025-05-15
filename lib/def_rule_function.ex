defmodule DefRuleFunction do


  defmacro def_rule_function(type, do: expression) do
    quote do
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      unquote("(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts)
      unquote(type |> IO.inspect(limit: :infinity))
      unquote("-----------------------------" |> IO.puts)
      unquote(expression |> IO.inspect(limit: :infinity))
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
      unquote("kwm;qbjqjvwkmbqjvkm;qjk;qjk;q" |> IO.puts)
    end
  end
end
