defmodule DefRule do
  alias Talisman.Rules

  def crack_fact_template_name_from_ast_node({:=, _, [{:%, _, [{:__aliases__, meta, parts} | _]} | _]} = node, env) do
    resolved = Macro.expand({:__aliases__, meta, parts}, env)
    parts_as_atoms = case resolved do
      atom when is_atom(atom) -> Module.split(atom) |> Enum.map(&String.to_existing_atom/1)
      {:__aliases__, _, new_parts} -> new_parts
      other ->
        raise "Unexpected Macro.expand result for #{inspect(node)}: #{inspect(other)}"
    end
    {:__aliases__, meta, parts_as_atoms}
  end

  def crack_fact_template_name_from_ast_node({:%, _, [{:__aliases__, meta, parts} | _]} = node, env) do
    resolved = Macro.expand({:__aliases__, meta, parts}, env)
    parts_as_atoms = case resolved do
      atom when is_atom(atom) -> Module.split(atom) |> Enum.map(&String.to_existing_atom/1)
      {:__aliases__, _, new_parts} -> new_parts
      other ->
        raise "Unexpected Macro.expand result for #{inspect(node)}: #{inspect(other)}"
    end
    {:__aliases__, meta, parts_as_atoms}
  end

  def crack_variable_name_from_ast_node({:=, _, [_struct_pattern, {var_name, _, _}]}) do
    var_name
  end

  def crack_fact_template_names_from_ast_node(closure_function_head, env) when is_list(closure_function_head) do
    closure_function_head
    |> Enum.map(fn node ->
      result = crack_fact_template_name_from_ast_node(node, env)
      result
    end)
    |> Enum.filter(& &1)
  end

  def crack_variable_names_from_ast_node(closure_function_head) when is_list(closure_function_head) do
    closure_function_head
    |> Enum.map(&crack_variable_name_from_ast_node/1)
    |> Enum.filter(& &1)
  end

  def crack_function_info_from_ast_node(
        {:fn, _, [{:->, _, [closure_function_head | [{_, _, [lhs_evaluation_body, rhs_execution_body]} | _]]} | _]}
      ) do
    {closure_function_head, lhs_evaluation_body, rhs_execution_body}
  end

  defmacro def_rule(rules, rule_name, rule) do
    {closure_function_head, lhs_evaluation_body, rhs_execution_body} = crack_function_info_from_ast_node(rule)
    fact_template_names = crack_fact_template_names_from_ast_node(closure_function_head, __CALLER__)
    variable_names = crack_variable_names_from_ast_node(closure_function_head)

    unique_fact_template_names = Enum.uniq(fact_template_names)
    fact_template_name_frequencies = fact_template_names
      |> Enum.frequencies()
      |> Enum.map(fn {{:__aliases__, meta, parts}, count} ->
        {{:__aliases__, meta, parts}, count}
      end)
      |> Map.new()

    quote do
      # Generate minimal dummy structs at runtime
      structs = unquote(Macro.escape(fact_template_names))
        |> Enum.map(fn
          {:__aliases__, _, parts} ->
            module = Module.concat(parts)
            struct(module)
          other ->
            raise "Unexpected fact template name: #{inspect(other)}"
        end)

      # Define the outer function
      outer_fn = fn unquote_splicing(closure_function_head) ->
        {unquote(lhs_evaluation_body), unquote(rhs_execution_body)}
      end

      # Store the outer function itself, to be called at runtime with asserted facts
      get_rule_lhs_evaluation_and_rhs_execution_functions = outer_fn

      Rules.add_rule(unquote(rules), unquote(rule_name), %{
        lhs_fact_template_names: unquote(Macro.escape(unique_fact_template_names
          |> Enum.map(fn {_, _, fact_template_name} ->
            Module.concat(fact_template_name)
          end))),
        lhs_fact_multiplicity: unquote(Macro.escape(fact_template_name_frequencies)),
        get_rule_lhs_evaluation_and_rhs_execution_functions: get_rule_lhs_evaluation_and_rhs_execution_functions
      })
    end
  end
end
