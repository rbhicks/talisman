defmodule Talisman.InferenceEngine do
  use GenServer

  alias Talisman.Facts
  alias Talisman.Rule
  alias Talisman.Rules
  alias Talisman.Mapper
  alias Talisman.Utilities

  #  def load ...
  #  def reset ...

  def set_facts(server, facts) do
    GenServer.call(server, {:set_facts, facts})
  end

  def set_rules(server, rules) do
    GenServer.call(server, {:set_rules, rules})
  end

  def run(server) do
    filter_rules_by_rule_lhs_and_asserted_fact_template_names(server)

    generate_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings(server)

    GenServer.call(server, :activate_and_execute_rules)

    :ok
  end

  def filter_rules_by_rule_lhs_and_asserted_fact_template_names(server) do
    :ok = GenServer.call(server, :filter_rules_by_rule_lhs_and_asserted_fact_template_names)
  end

  def generate_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings(server) do
    :ok =
      GenServer.call(
        server,
        :generate_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings
      )
  end

  def execute_activated_rules(server) do
    :ok = GenServer.call(server, :execute_activated_rules)
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

  def handle_call(
        :filter_rules_by_rule_lhs_and_asserted_fact_template_names,
        _from,
        %{facts: facts, rules: rules, mapper: mapper} = state
      ) do
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # look into tightening this up
    # look into tightening this up
    # look into tightening this up
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    asserted_facts = Facts.get_asserted_facts(facts)
    fact_template_to_rule_lhs_mapping = Mapper.get_fact_template_name_to_rule_lhs_mapping(mapper)

    asserted_fact_templates_names =
      for {_, {asserted_fact_template_name, _}} <- asserted_facts do
        asserted_fact_template_name
      end
      |> MapSet.new()
      |> MapSet.to_list()
      |> MapSet.new()

    rule_lhs_fact_template_names =
      for {_, {rule_name, rule_pid}} <- rules |> Rules.get_rules() do
        {rule_name, rule_pid |> Rule.get_lhs_fact_template_names() |> MapSet.new()}
      end

    mapped_rules =
      asserted_fact_templates_names
      |> Enum.filter(fn asserted_fact_template_name ->
        Map.get(fact_template_to_rule_lhs_mapping, asserted_fact_template_name)
      end)
      |> Enum.reduce([], fn asserted_fact_template_name, acc ->
        fact_template_to_rule_lhs_mapping
        |> Map.get(asserted_fact_template_name)
        |> Kernel.++(acc)
      end)

    rules_filtered_by_lhs_and_asserted_fact_template_names =
      mapped_rules
      |> Enum.filter(fn rule_name ->
        rule_lhs_fact_template_names[rule_name]
        |> MapSet.subset?(asserted_fact_templates_names)
      end)
      |> Enum.uniq()

    {
      :reply,
      :ok,
      state
      |> Map.put(
        :rules_filtered_by_lhs_and_asserted_fact_template_names,
        rules_filtered_by_lhs_and_asserted_fact_template_names
      )
    }
  end

  def handle_call(
        :generate_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings,
        _from,
        %{
          facts: facts,
          rules: rules,
          rules_filtered_by_lhs_and_asserted_fact_template_names:
            rules_filtered_by_lhs_and_asserted_fact_template_names,
          mapper: mapper
        } = state
      ) do
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # woeful duplication or effort, recalculation,
    # inefficiency, etc. get it working and then consolidate
    # all the stage calculations
    # also, "stage two candidate ......" may need a new name,
    # i.e., does it accurately reflect what's happeneing?
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    fact_template_name_to_asserted_facts_mapping =
      Mapper.get_fact_template_name_to_asserted_facts_mapping(mapper)

    fact_template_to_rule_lhs_mapping = Mapper.get_fact_template_name_to_rule_lhs_mapping(mapper)

    asserted_fact_templates_names =
      for {_, {asserted_fact_template_name, _}} <- Facts.get_asserted_facts(facts) do
        asserted_fact_template_name
      end

    rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings =
      rules
      |> Rules.get_rules()
      |> Enum.filter(fn {_, {rule_name, _rule_pid}} ->
        rules_filtered_by_lhs_and_asserted_fact_template_names |> Enum.member?(rule_name)
      end)
      |> Enum.reduce([], fn {_, {rule_name, rule_pid}}, acc ->
        rule_info = {rule_name, rule_pid, Rule.get_lhs_fact_template_names(rule_pid)}

        [rule_info | acc]
      end)
      |> Enum.filter(fn {rule_name, rule_pid, rule_lhs_fact_template_names} ->
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

    {
      :reply,
      :ok,
      state
      |> Map.put(
        :rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings,
        rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings
      )
    }
  end

  def handle_call(
        :activate_and_execute_rules,
        _from,
        %{
          facts: facts,
          rules: rules,
          rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings: rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings,
          rules_filtered_by_lhs_and_asserted_fact_template_names: rules_filtered_by_lhs_and_asserted_fact_template_names
        } = state
      ) do

    rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity = filter_rules_by_rule_lhs_and_asserted_fact_multiplicity(rules_filtered_by_lhs_and_asserted_fact_template_names, facts, rules)

    activated_rules = rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings
    |> generate_candidate_rule_activations(rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity)
    |> generate_activated_rules()
    
    
    for {_, _, rhs_execution_functions} <- activated_rules do
      for {_, rhs_execution_function} <- rhs_execution_functions do
        rhs_execution_function.()
      end
    end

    {
      :reply,
      :ok,
      state
    }
  end

  def start(params) do
    GenServer.start_link(__MODULE__, params)
  end

  def init(mapper: mapper) do
    {
      :ok,
      %{
        facts: nil,
        rules: nil,
        mapper: mapper,
        rules_filtered_by_lhs_and_asserted_fact_template_names: [],
        rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings: [],
        rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity: []
      }
    }
  end

  def filter_rules_by_rule_lhs_and_asserted_fact_multiplicity(rules_filtered_by_lhs_and_asserted_fact_template_names, facts, rules) do
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
      |> Enum.filter(fn {_, {rule_name, rule_pid}} ->
        lhs_fact_multiplicity = Rule.get_lhs_fact_multiplicity(rule_pid)

        lhs_fact_multiplicity
        |> Enum.reduce_while(true, fn {lhs_fact_template_name,
                                       lhs_fact_template_name_multiplicity},
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

  def generate_candidate_rule_activations(rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings,
    rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity) do
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
        {
          rule_name,
          rule_pid,
          Rule.evaluate_lhs_for_asserted_facts(
            rule_pid,
            Utilities.create_cartesian_product(asserted_facts)
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
end
