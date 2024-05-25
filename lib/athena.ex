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


    # [
    #   [1, 3, 5],
    #   [1, 3, 6],
    #   [1, 4, 5],
    #   [1, 4, 6],
    #   [2, 3, 5],
    #   [2, 3, 6],
    #   [2, 4, 5],
    #   [2, 4, 6]
    # ]

    [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
#    |> ack([], [], [])
    |> jbe([], [], [])
#    |> IO.inspect(limit: :infinity)
    
    "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}" |> IO.puts
    "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{" |> IO.puts
    "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}" |> IO.puts
    
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  # [
  #   [1, 4, 7], [1, 4, 8], [1, 4, 9], [1, 5, 7], [1, 5, 8],
  #   [1, 5, 9], [1, 6, 7], [1, 6, 8], [1, 6, 9],
  #   [2, 4, 7], [2, 4, 8], [2, 4, 9], [2, 5, 7], [2, 5, 8],
  #   [2, 5, 9], [2, 6, 7], [2, 6, 8], [2, 6, 9],
  #   [3, 4, 7], [3, 4, 8], [3, 4, 9], [3, 5, 7], [3, 5, 8],
  #   [3, 5, 9], [3, 6, 7], [3, 6, 8], [3, 6, 9]
  # ]

  # "kbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbx" |> IO.puts
  # "kbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbx" |> IO.puts
  # "kbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbx" |> IO.puts
  # "!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!" |> IO.puts
  # "!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!" |> IO.puts
  # "!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!" |> IO.puts
  # "@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@" |> IO.puts
  # "@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@" |> IO.puts
  # "@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@" |> IO.puts
  # "§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§" |> IO.puts
  # "§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§" |> IO.puts
  # "§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§" |> IO.puts
  # "oateuhaoseutnhaoesutaeohusaeotuhaousuaoeu" |> IO.puts
  # "oateuhaoseutnhaoesutaeohusaeotuhaousuaoeu" |> IO.puts
  # "oateuhaoseutnhaoesutaeohusaeotuhaousuaoeu" |> IO.puts
  # "32902392039230920392039203920390293023990" |> IO.puts
  # "32902392039230920392039203920390293023990" |> IO.puts
  # "32902392039230920392039203920390293023990" |> IO.puts

  #[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

  #[[2, 3], [4, 5, 6], [7, 8, 9]]

  # [1]    -> [[5, 6], [7, 8, 9]]  
  # [1, 4] -> [[7, 8, 9]]
  
  # [[1, 4, 7], [1, 4, 8], [1, 4, 9]]
  
  # [1]    -> [[6], [7, 8, 9]]
  # [1, 5] -> [[7, 8, 9]]


  # [[2, 3], [4, 5, 6], [7, 8, 9]]
  # [[5, 6], [7, 8, 9]]  
  # [[8, 9]]

  # [[3], [4, 5, 6], [7, 8, 9]]
  # [[5, 6], [7, 8, 9]]  
  # [[8, 9]]



#  def jbe([[]], [[[]|stack_head_tail]|stack_tail] = stack, [current_head|current_tail] = current, product) do
  def jbe([[]], [[[]|_]|stack_tail], [current_head|current_tail] = current, product) do

    "***************************************************" |> IO.puts
    "***************************************************" |> IO.puts
    "***************************************************" |> IO.puts
#    stack_head_tail |> IO.inspect(limit: :infinity, charlists: :as_lists)
    stack_tail |> IO.inspect(limit: :infinity, charlists: :as_lists)
#    stack |> IO.inspect(limit: :infinity, charlists: :as_lists)
    current |> IO.inspect(limit: :infinity, charlists: :as_lists)
    product |> IO.inspect(limit: :infinity, charlists: :as_lists)
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    jbe(stack_tail, stack_tail, [], product)
  end
  
  # the first parameter has another enclosing list, unlike the
  # almost identical follwing head, because we're getting the
  # param from the stack rather than the input list of lists.
  # the stack is list of lists of lists.
  def jbe([[]], [stack_head|stack_tail] = stack, [current_head|current_tail] = current, product) do
    ",.p,.p.,p,.p,.p.,p.,p,.p,.p,.p,.p,p,.p,p" |> IO.puts
    ",.p,.p.,p,.p,.p.,p.,p,.p,.p,.p,.p,p,.p,p" |> IO.puts
    ",.p,.p.,p,.p,.p.,p.,p,.p,.p,.p,.p,p,.p,p" |> IO.puts
    stack_head |> IO.inspect(limit: :infinity, charlists: :as_lists)
    stack_tail |> IO.inspect(limit: :infinity, charlists: :as_lists)
    current_head |> IO.inspect(limit: :infinity, charlists: :as_lists)
    current_tail |> IO.inspect(limit: :infinity, charlists: :as_lists)
    product |> IO.inspect(limit: :infinity, charlists: :as_lists)
    stack |> IO.inspect(limit: :infinity, charlists: :as_lists)
    ")(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)" |> IO.puts
    ")(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)" |> IO.puts
    ")(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)" |> IO.puts
    jbe(stack_head, stack_tail, current_tail, product)
  end
  
  def jbe([], [stack_head|stack_tail] = stack, [current_head|current_tail] = current, product) do
    "@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@" |> IO.puts
    "@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@" |> IO.puts
    "@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@" |> IO.puts
    stack_head |> IO.inspect(limit: :infinity, charlists: :as_lists)
    stack_tail |> IO.inspect(limit: :infinity, charlists: :as_lists)
    current_head |> IO.inspect(limit: :infinity, charlists: :as_lists)
    current_tail |> IO.inspect(limit: :infinity, charlists: :as_lists)
    product |> IO.inspect(limit: :infinity, charlists: :as_lists)
    [current |> Enum.reverse|product] |> IO.inspect(limit: :infinity, charlists: :as_lists)
    current |> IO.inspect(limit: :infinity, charlists: :as_lists)
    stack |> IO.inspect(limit: :infinity, charlists: :as_lists)
    "§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§" |> IO.puts
    "§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§" |> IO.puts
    "§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§" |> IO.puts
    jbe(stack_head, stack_tail, current_tail, [current |> Enum.reverse|product])
    
  end
  
  def jbe([[head|tail_0]|tail_1], stack, current, product) do
    "oateuhaoseutnhaoesutaeohusaeotuhaousuaoeu" |> IO.puts
    "oateuhaoseutnhaoesutaeohusaeotuhaousuaoeu" |> IO.puts
    "oateuhaoseutnhaoesutaeohusaeotuhaousuaoeu" |> IO.puts
    head |> IO.inspect(limit: :infinity, charlists: :as_tail)
    tail_0 |> IO.inspect(limit: :infinity, charlists: :as_lists)
    tail_1 |> IO.inspect(limit: :infinity, charlists: :as_lists)
    stack |> IO.inspect(limit: :infinity, charlists: :as_lists)
    current |> IO.inspect(limit: :infinity, charlists: :as_lists)
    product |> IO.inspect(limit: :infinity, charlists: :as_lists)
    [[tail_0|tail_1]|stack] |> IO.inspect(limit: :infinity, charlists: :as_lists)
    [head|current] |> IO.inspect(limit: :infinity, charlists: :as_lists)
    stack |> IO.inspect(limit: :infinity, charlists: :as_lists)
    "32902392039230920392039203920390293023990" |> IO.puts
    "32902392039230920392039203920390293023990" |> IO.puts
    "32902392039230920392039203920390293023990" |> IO.puts
    jbe(tail_1, [[tail_0|tail_1]|stack], [head|current], product)
  end







  


  

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
