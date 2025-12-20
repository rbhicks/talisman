defmodule Talisman.InferenceEngine do
  use GenServer

  alias Talisman.Facts
  alias Talisman.Rule
  alias Talisman.Rules
  alias Talisman.Mapper
  alias Talisman.Utilities

  def set_facts(server, facts) do
    GenServer.call(server, {:set_facts, facts})
  end

  def set_rules(server, rules) do
    GenServer.call(server, {:set_rules, rules})
  end

  def set_mapper(server, mapper) do
    GenServer.call(server, {:set_mapper, mapper})
  end

  def load(server, fact_load_modules) do
    GenServer.call(server, {:load, fact_load_modules})
  end

  def compile_rules(server, rule_compile_modules) do
    GenServer.call(server, {:compile_rules, rule_compile_modules})
  end

  # ???????????????
  # ???????????????
  # ???????????????
  #  def reset
  # ???????????????
  # ???????????????
  # ???????????????

  def run(server) do
    GenServer.call(server, :run)
  end

  def clear(server) do
    GenServer.call(server, :clear)
  end

  def handle_call({:set_facts, facts}, _, state) do
    {
      :reply,
      :ok,
      state
      |> Map.put(:facts, facts)
    }
  end

  def handle_call({:set_rules, rules}, _, state) do
    {
      :reply,
      :ok,
      state
      |> Map.put(:rules, rules)
    }
  end

  def handle_call({:set_mapper, mapper}, _, state) do
    {
      :reply,
      :ok,
      state
      |> Map.put(:mapper, mapper)
    }
  end

  def handle_call(
        {:load, fact_load_modules},
        _from,
        %{
          facts: facts
        } = state
      ) do
    for fact_load_module <- fact_load_modules do
      apply(fact_load_module, :load, [facts])
    end

    {
      :reply,
      :ok,
      state
    }
  end

  def handle_call(
        {:compile_rules, rule_compile_modules},
        _from,
        %{
          facts: facts,
          rules: rules
        } = state
      ) do
    for rule_compile_module <- rule_compile_modules do
      apply(rule_compile_module, :compile_rules, [facts, rules])
    end

    {
      :reply,
      :ok,
      state
    }
  end

  def handle_call(
        :run,
        _from,
        %{
          facts: facts,
          rules: rules,
          mapper: mapper
        } = state
      ) do
    get_actitvated_rules(facts, rules, mapper)
    |> activate_and_execute_rules(facts, rules, mapper, [])

    {
      :reply,
      :ok,
      state
    }
  end

  def handle_call(
        :clear,
        _from,
        %{
          facts: facts,
          mapper: mapper
        } = state
      ) do
    Facts.purge_asserted_facts(facts)
    Mapper.purge_fact_template_name_to_asserted_facts_mapping(mapper)

    {
      :reply,
      :ok,
      state
    }
  end

  def start() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {
      :ok,
      %{
        facts: nil,
        rules: nil,
        mapper: nil
      },
      10000
    }
  end

  ################################################################################
  ################################################################################
  ###################               INTERNAL              ########################
  ###################  not private so they can be tested  ########################
  ################################################################################
  ################################################################################

  def activate_and_execute_rules([], _facts, _rules, _mapper, executed_rules), do: executed_rules

  def activate_and_execute_rules(activated_rules, facts, rules, mapper, executed_rules) do
    # activated_rules is a flattened list with redundant data
    # as it needs to be be that way to properly do rule processing
    # except for rules that are purely for side effects, not most
    # in all likelihood, we need to recheck activations every time
    # a rule is fire in that the assertion, retraction, or updating
    # of a fact could affect activations. to make this tractable,
    # we need such a flattened list. we'll keep track of the rule
    # and fact pid list that caused it to fire. if that same rule
    # and fact list combination is still present, we skip executing
    # the rule and move one until we're done.
    #
    # N.B.:
    #       1) in the above case, and others, a rule may in fact fire
    #          again.
    #       2) yes, it's possible that this could result in an infinite
    #          loop. however, this a rule logic problem and not a talisman
    #          problem.
    rule_to_execute =
      activated_rules
      |> Enum.find(fn activated_rule ->
        !Enum.member?(executed_rules, activated_rule)
      end)

    execute_rule(rule_to_execute)

    (get_actitvated_rules(facts, rules, mapper) -- executed_rules)
    |> activate_and_execute_rules(facts, rules, mapper, [rule_to_execute | executed_rules])
  end

  def execute_rule(nil), do: nil
  def execute_rule({_, _, _, rhs_execution_function}), do: rhs_execution_function.()

  def get_actitvated_rules(facts, rules, mapper) do
    rules_filtered_by_lhs_and_asserted_fact_template_names =
      filter_rules_by_rule_lhs_and_asserted_fact_template_names(facts, rules, mapper)

    rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity =
      filter_rules_by_rule_lhs_and_asserted_fact_multiplicity(
        rules_filtered_by_lhs_and_asserted_fact_template_names,
        facts,
        rules
      )

    rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings =
      generate_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings(
        rules_filtered_by_lhs_and_asserted_fact_template_names,
        rules,
        mapper
      )

    rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings
    |> generate_candidate_rule_activations(
      rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity
    )
    |> generate_activated_rules()
    # have to combine and flatten these to make the
    # fact maintencance and rule execution logic work
    |> Enum.map(fn {rule_name, rule_pid, activations} ->
      activations
      |> Enum.map(fn {fact_pids, rhs_execution_function} ->
        {rule_name, rule_pid, fact_pids, rhs_execution_function}
      end)
    end)
    |> Enum.flat_map(fn activation_info -> activation_info end)
  end

  def filter_rules_by_rule_lhs_and_asserted_fact_template_names(facts, rules, mapper) do
    asserted_facts = Facts.get_asserted_facts(facts)
    fact_template_to_rule_lhs_mapping = Mapper.get_fact_template_name_to_rule_lhs_mapping(mapper)
    asserted_fact_templates_names = get_asserted_fact_templates_names(asserted_facts)
    rule_lhs_fact_template_names = get_rule_lhs_fact_template_names(rules)

    mapped_rules =
      get_mapped_rules(asserted_fact_templates_names, fact_template_to_rule_lhs_mapping)

    mapped_rules
    |> Enum.filter(fn rule_name ->
      rule_lhs_fact_template_names[rule_name]
      |> MapSet.subset?(asserted_fact_templates_names)
    end)
    |> Enum.uniq()
  end

  def generate_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings(
        rules_filtered_by_lhs_and_asserted_fact_template_names,
        rules,
        mapper
      ) do
    fact_template_name_to_asserted_facts_mapping =
      Mapper.get_fact_template_name_to_asserted_facts_mapping(mapper)

    fact_template_to_rule_lhs_mapping = Mapper.get_fact_template_name_to_rule_lhs_mapping(mapper)

    get_filtered_rules(rules, rules_filtered_by_lhs_and_asserted_fact_template_names)
    |> get_filtered_rules_information()
    |> filter_filtered_rules_information_by_asserted_fact_mappings(
      fact_template_to_rule_lhs_mapping
    )
    |> Enum.reduce([], fn {rule_name, rule_pid, rule_lhs_fact_template_names}, acc ->
      [
        {
          rule_name,
          rule_pid,
          for rule_lhs_fact_template_name <- rule_lhs_fact_template_names do
            Map.get(fact_template_name_to_asserted_facts_mapping, rule_lhs_fact_template_name)
          end
        }
        | acc
      ]
    end)
  end

  def filter_rules_by_rule_lhs_and_asserted_fact_multiplicity(
        rules_filtered_by_lhs_and_asserted_fact_template_names,
        facts,
        rules
      ) do
    asserted_facts = Facts.get_asserted_facts(facts)
    current_rules = Rules.get_rules(rules)

    asserted_facts_template_name_frequencies =
      asserted_facts
      |> Map.values()
      |> Enum.map(fn {asserted_fact_template_name, _} ->
        asserted_fact_template_name
      end)
      |> Enum.frequencies()

    current_rules
    |> Map.take(rules_filtered_by_lhs_and_asserted_fact_template_names)
    |> Enum.filter(fn {_, {_rule_name, rule_pid}} ->
      lhs_fact_multiplicity = Rule.get_lhs_fact_multiplicity(rule_pid)

      lhs_fact_multiplicity
      |> Enum.reduce_while(true, fn {lhs_fact_template_name, lhs_fact_template_name_multiplicity},
                                    acc ->
        if(
          Map.get(asserted_facts_template_name_frequencies, lhs_fact_template_name) >=
            lhs_fact_template_name_multiplicity
        ) do
          {:cont, acc}
        else
          {:halt, false}
        end
      end)
    end)
  end

  def generate_candidate_rule_activations(
        rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings,
        rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity
      ) do
    for {mapping_rule_name, _, _} = mapping <-
          rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings,
        {_, {rule_name, _}} <- rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity,
        mapping_rule_name == rule_name do
      mapping
    end
  end

  def generate_activated_rules(candidate_rule_activations) do
    candidate_rule_activations
    |> Enum.map(fn {rule_name, rule_pid, asserted_facts} ->
      asserted_fact_lhs_sets =
        asserted_facts
        |> Utilities.create_cartesian_product()
        |> remove_redundant_asserted_fact_lhs_sets()

      {
        rule_name,
        rule_pid,
        Rule.evaluate_lhs_for_asserted_facts(
          rule_pid,
          asserted_fact_lhs_sets
        )
      }
    end)
    # the semantics of Rule.evaluate_lhs_for_asserted_facts is
    # to return an empty list where the rhs execution function
    # should be. so filter it.
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # this ^^^^ is wonky...fix it.
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    |> Enum.reject(fn {_, _, rhs_execution_function} ->
      rhs_execution_function
      |> Enum.empty?()
    end)
  end

  #################################################################
  ##################### internal functions##########################
  #################################################################

  defp get_asserted_fact_templates_names(asserted_facts) do
    for {_, {asserted_fact_template_name, _}} <- asserted_facts do
      asserted_fact_template_name
    end
    |> MapSet.new()
  end

  defp get_rule_lhs_fact_template_names(rules) do
    for {_, {rule_name, rule_pid}} <- rules |> Rules.get_rules() do
      {rule_name, rule_pid |> Rule.get_lhs_fact_template_names() |> MapSet.new()}
    end
  end

  defp get_mapped_rules(asserted_fact_templates_names, fact_template_to_rule_lhs_mapping) do
    asserted_fact_templates_names
    |> Enum.filter(fn asserted_fact_template_name ->
      Map.get(fact_template_to_rule_lhs_mapping, asserted_fact_template_name)
    end)
    |> Enum.reduce([], fn asserted_fact_template_name, acc ->
      fact_template_to_rule_lhs_mapping
      |> Map.get(asserted_fact_template_name)
      |> Kernel.++(acc)
    end)
  end

  defp get_filtered_rules(rules, rules_filtered_by_lhs_and_asserted_fact_template_names) do
    rules
    |> Rules.get_rules()
    |> Enum.filter(fn {_, {rule_name, _rule_pid}} ->
      rules_filtered_by_lhs_and_asserted_fact_template_names |> Enum.member?(rule_name)
    end)
  end

  defp get_filtered_rules_information(filtered_rules) do
    filtered_rules
    |> Enum.reduce([], fn {_, {rule_name, rule_pid}}, acc ->
      rule_info = {rule_name, rule_pid, Rule.get_lhs_fact_template_names(rule_pid)}

      [rule_info | acc]
    end)
  end

  defp filter_filtered_rules_information_by_asserted_fact_mappings(
         filered_rules_information,
         fact_template_name_to_asserted_facts_mapping
       ) do
    filered_rules_information
    |> Enum.filter(fn {_rule_name, _rule_pid, rule_lhs_fact_template_names} ->
      rule_lhs_fact_template_names
      |> Enum.reduce_while(true, fn rule_lhs_fact_template_name, acc ->
        if(
          Map.has_key?(
            fact_template_name_to_asserted_facts_mapping,
            rule_lhs_fact_template_name
          )
        ) do
          {:cont, acc}
        else
          {:halt, false}
        end
      end)
    end)
  end

  # this prevents additional activations when the same fact template
  # is used multiple times and the only difference is the order.
  defp remove_redundant_asserted_fact_lhs_sets(asserted_facts_cartesian_product) do
    {unique_asserted_fact_lhs_sets, _sorted_added_asserted_fact_lhs_sets} =
      asserted_facts_cartesian_product
      |> Enum.reduce({[], []}, fn asserted_fact_lhs_set,
                                  {acc_unique_asserted_fact_lhs_sets,
                                   acc_sorted_added_asserted_fact_lhs_sets} = acc ->
        sorted_asserted_fact_lhs_set = Enum.sort(asserted_fact_lhs_set)

        if not Enum.member?(acc_sorted_added_asserted_fact_lhs_sets, sorted_asserted_fact_lhs_set) do
          {[asserted_fact_lhs_set | acc_unique_asserted_fact_lhs_sets],
           [sorted_asserted_fact_lhs_set | acc_sorted_added_asserted_fact_lhs_sets]}
        else
          acc
        end
      end)

    unique_asserted_fact_lhs_sets
  end
end
