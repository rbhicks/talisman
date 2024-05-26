defmodule Athena do
  @moduledoc """
  Documentation for `Athena`.
  """

  def start(_type, _args) do

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" |> IO.puts
    "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" |> IO.puts
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" |> IO.puts

    # quote do
    #   1 + 2 * 3
    # end
    # |> IO.inspect(limit: :infinity)

    # simple_match(:ack, "2187") |> IO.inspect(limit: :infinity)
    # simple_function_match(:ack, &Integer.to_string/1, 2187) |> IO.inspect(limit: :infinity)



    
    #inference_engine_check_lhs_for_rule_activation() |> IO.inspect(limit: :infinity)

#    cartesian_product([[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14]])
    # cartesian_product([[1, 2], [3, 4], [5, 6]])
    # |> IO.inspect(limit: :infinity)

#    [[1, 2], [3, 4]]
#    [[1, 2], [3, 4], [5, 6]]
#    [[1, 2], [3, 4], [5, 6], [7, 8]]
#    [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]]
#    [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
#    [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]
#     [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]
#    [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
#    |> ack([], [], [])
#    |> jbe([], [], [])
#     |> jbe([])
#    fox_3([[1], [2]], [3, 4], [])
#    fox_3([[1, 3], [1, 4], [2, 3], [2, 4]], [5, 6], [])
    
#     |> fox_1()
#    |> cartesian_product()
#    |> IO.inspect(limit: :infinity)

    Benchee.run(
      %{
        "fox_n" => fn -> [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]] |> fox_1() end,
        "cartesian_product" => fn -> [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]] |> cartesian_product() end
        },
      time: 10,
      memory_time: 2
    )

    
    "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}" |> IO.puts
    "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{" |> IO.puts
    "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}" |> IO.puts
    
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def cartesian_product(lists) do
    lists
    |> Enum.reduce([[]], fn list, acc ->
      for x <- acc, y <- list, do: x ++ [y]
    end)
  end


  # bailing on this and going with the above. i'm putting in the stats and
  # comments into a commit for history record.
  
# Name                        ips        average  deviation         median         99th %
# cartesian_product      547.85 K        1.83 μs   ±685.95%        1.71 μs        2.13 μs
# fox_n                  151.24 K        6.61 μs   ±126.97%        6.21 μs       13.79 μs

# Comparison:
# cartesian_product      547.85 K
# fox_n                  151.24 K - 3.62x slower +4.79 μs

# Memory usage statistics:

# Name                 Memory usage
# cartesian_product        11.73 KB
# fox_n                    63.14 KB - 5.38x memory usage +51.41 KB

# **All measurements for memory usage were the same**

  def jumpstart_acc([], acc), do: acc
  def jumpstart_acc([head|tail], acc), do: jumpstart_acc(tail, acc ++ [[] ++ [head]])
  
  def fox_1([head|tail]) do
    fox_1(tail, jumpstart_acc(head, []))
  end
  def fox_1([], acc), do: acc
  def fox_1([head|tail], acc) do
    fox_1(tail, fox_2(acc, head, []))
  end
  
  def fox_2([], _hellfire, acc), do: acc
  def fox_2([head|tail], hellfire, acc) do
    fox_2(tail, hellfire, fox_3(head, hellfire, acc))
  end

  def fox_3(_sidewinder, [], acc), do: acc
  def fox_3(sidewinder, [head|tail], acc) do
    fox_3(sidewinder, tail, acc ++ [sidewinder ++ [head]])
  end

  # this version isn't sorted properly, but rather than deal with that
  # i ran the bench mark since fixing the sort would only make it take
  # longer. thus, if there was significant improvement, that would
  # justify fixing it. (no joy. all it fucking did was flip the memory
  # usage and speed performance (roughly). i.e., this was even slower.

# Name                        ips        average  deviation         median         99th %
# fox_n                    2.78 M        0.36 μs ±11986.44%        0.25 μs        0.42 μs
# cartesian_product        0.55 M        1.83 μs   ±862.80%        1.71 μs        2.17 μs

# Comparison:
# fox_n                    2.78 M
# cartesian_product        0.55 M - 5.08x slower +1.47 μs

# Memory usage statistics:

# Name                 Memory usage
# fox_n                     3.75 KB
# cartesian_product        11.73 KB - 3.13x memory usage +7.98 KB

# **All measurements for memory usage were the same**


  # def jumpstart_acc([], acc), do: acc
  # def jumpstart_acc([head|tail], acc), do: jumpstart_acc(tail, [[head]|acc])

  
  # def fox_1([head|tail]) do
  #   fox_1(tail, jumpstart_acc(head, []))
  # end
  # def fox_1([], acc), do: acc
  # def fox_1([head|tail], acc) do
  #   fox_1(tail, fox_2(acc, head, []))
  # end
  
  # def fox_2([], _hellfire, acc), do: acc
  # def fox_2([head|tail], hellfire, acc) do
  #   fox_2(tail, hellfire, fox_3(head, hellfire, acc)) 
  # end
  
  # def fox_3(_sidewinder, [], acc), do: acc
  # def fox_3(sidewinder, [head|tail] = hellfire, acc) do
  #   fox_3(sidewinder, tail, [[head|sidewinder]|acc])
  # end  

  

  #########################################################
  # rule prototypes
  #
  # (defrule simple_match
  #   (ack "2187")
  #   =>
  #   (assert something)
  # )
  #
  # (defrule internal_binding_match
  #   (ack ?ack)
  #   (oop ?ack)
  #   =>
  #   (assert something)
  # )
  #########################################################

  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  #this probably wrong and should be derived from facts
  #
  #the match functions also need to be changed
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # @bindings %{
  #   "ack" => ["2187", "1138"]
  #   "internal_binding_match_lhs_bindings" => %{
  #     "ack_000000" => "ack"
  #   }
  # }

  # def get_bound_value(binding), do: @bindings[binding]
  
  # def simple_match(binding, value), do: get_bound_value(binding) == value

  # def simple_function_match(binding, function, value), do: get_bound_value(binding) == function.(value)

  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  #this probably wrong and should be derived from facts
  #
  #the match functions also need to be changed
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  # @facts [
  #   %{
  #     "type" => "ordered",
  #     "values" => ["fox_1", "something"]
  #   },
  #   %{
  #     "type" => "ordered",
  #     "values" => ["fox_1", "bloo"]
  #   },
  #   %{
  #     "type" => "non_ordered",
  #     "template" => "ack",
  #     "key_value_pairs" => [
  #       {"oop", "fzzzt"}
  #     ]
  #   },
  #   %{
  #     "type" => "non_ordered",
  #     "template" => "jbe",
  #     "key_value_pairs" => [
  #       {"zorg", "fzzzt"}
  #     ]
  #   },
  #   %{
  #     "type" => "non_ordered",
  #     "template" => "ack",
  #     "key_value_pairs" => [
  #       {"oop", "zoom"}
  #     ]
  #   },
  #   %{
  #     "type" => "non_ordered",
  #     "template" => "jbe",
  #     "key_value_pairs" => [
  #       {"zorg", "bang"}
  #     ]
  #   },
  #   %{
  #     "type" => "non_ordered",
  #     "template" => "jbe",
  #     "key_value_pairs" => [
  #       {"zorg", "something"}
  #     ]
  #   },
  #   %{
  #     "type" => "non_ordered",
  #     "template" => "jbe",
  #     "key_value_pairs" => [
  #       {"zorg", "wat"}
  #     ]
  #   }
  # ]
  
  # @rules [
  #   %{
  #     "name" => "internal_binding_match",
  #     "lhs" => %{
  #       "clauses" => [
  #         ["fox_1", "gensym_ack_000000"],
  #         {"ack", "oop", "gensym_ack_000001"},
  #         {"jbe", "zorg", "gensym_ack_000001"},
  #         {"jbe", "zorg", "gensym_ack_000000"}
  #       ]
  #     },
  #     "rhs" => %{
  #       "actions" => [{&IO.puts/1, ["gensym_ack_000000"]}]
  #     }
  #   }
  # ]
  
  # def inference_engine_check_lhs_for_rule_activation() do
  #   @rules
  #   |> Enum.map(fn rule ->
  #     nil
  #   end)
  # end  
end
