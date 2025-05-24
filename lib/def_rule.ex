defmodule DefRule do

  alias Talisman.Rules

  @doc """
  crack a fact template name that is also set to a variable
  """
  def crack_fact_template_name_from_ast_node({:=, _, [{:%, _, [{_, _, [fact_template_name|_]}|_]}|_]}) do
    fact_template_name
  end

  @doc """
  crack a fact template name that is by itself for pattern matching,
  not set to a variable
  """
  def crack_fact_template_name_from_ast_node({:%, _, [{_, _, [fact_template_name|_]}|_]}) do
    fact_template_name
  end
  
  def crack_fact_template_names_from_ast_node({_, _, [{_, _, [[]|_]}|_]}), do: []
  def crack_fact_template_names_from_ast_node({_, _, [{_, _, [fact_template_names_ast|_]}|_]}) do    
    fact_template_names_ast
    |> Enum.map(fn fact_template_name_ast_node ->
      crack_fact_template_name_from_ast_node(fact_template_name_ast_node)
    end)
  end

  def crack_function_info_from_ast_node({:fn, _, [{:->, _, [closure_function_head|[{_, _, [lhs_evaluation_body|rhs_execution_body]}|_]]}|_]}) do
    {closure_function_head, lhs_evaluation_body, rhs_execution_body}
  end

  defmacro def_rule(rule_name, rule) do

    fact_template_names = crack_fact_template_names_from_ast_node(rule)
    {closure_function_head, lhs_evaluation_body, rhs_execution_body} = crack_function_info_from_ast_node(rule)
    unique_fact_template_names = fact_template_names
    |> Enum.uniq
    fact_template_name_frequencies = fact_template_names
    |> Enum.frequencies

    prepare_and_restrieve_functions = {:fn, [],
                                       [
                                         {:->, [],
                                         [
                                           closure_function_head,
                                           {
                                             lhs_evaluation_body,
                                             rhs_execution_body
                                           }
                                         ]}
                                       ]}

    prepare_and_restrieve_functions

    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # have to produce this
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    # {:%{}, [],
    #  [
    #    lhs_fact_template_names: [
    #      {:__aliases__, [alias: false], [:MissileFactTemplate]},
    #      {:__aliases__, [alias: false], [:PropulsionFactTemplate]}
    #    ],
    #    lhs_fact_multiplicity: {:%{}, [],
    #                            [
    #                              {{:__aliases__, [alias: false], [:MissileFactTemplate]}, 1},
    #                              {{:__aliases__, [alias: false], [:PropulsionFactTemplate]}, 1}
    #                            ]},
    #    evaluate_lhs_function: {:fn, [],
    #      [{:->, [], [[{:fact_instances, [], Elixir}], nil]}]},
    #  execute_rule_function: {:fn, [], [{:->, [], [[], nil]}]}
    #  ]}
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
