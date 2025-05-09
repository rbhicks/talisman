defmodule Talisman.InferenceEngine do
  use GenServer

  alias Talisman.Facts
  alias Talisman.Rule
  alias Talisman.Rules
  alias Talisman.Mapper
  alias Talisman.Utilities

  #  def load ...
  #  def reset ...
  #  def run ...

  #  defp add_activated_rule ...
  #  defp resolve_execution_order ...

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

  def filter_rules_by_rule_lhs_and_asserted_fact_multiplicy(server) do
    :ok = GenServer.call(server, :filter_rules_by_rule_lhs_and_asserted_fact_multiplicy)
  end

  def generate_rule_activations(server) do
    :ok = GenServer.call(server, :generate_rule_activations)
  end

  def get_rules_filtered_by_lhs_and_asserted_fact_template_names(server) do
    {:ok, rules_filtered_by_lhs_and_asserted_fact_template_names} =
      GenServer.call(server, :get_rules_filtered_by_lhs_and_asserted_fact_template_names)

    rules_filtered_by_lhs_and_asserted_fact_template_names
  end

  def get_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings(server) do
    {:ok, rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings} =
      GenServer.call(
        server,
        :get_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings
      )

    rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings
  end

  def get_rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy(server) do
    {:ok, rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy} =
      GenServer.call(server, :get_rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy)

    rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy
  end

  def get_rule_activations(server) do
    {:ok, rule_activations} = GenServer.call(server, :get_rule_activations)
    rule_activations
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
        :filter_rules_by_rule_lhs_and_asserted_fact_multiplicy,
        _from,
        %{
          facts: facts,
          rules: rules,
          rules_filtered_by_lhs_and_asserted_fact_template_names:
            rules_filtered_by_lhs_and_asserted_fact_template_names
        } = state
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

    rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy =
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
        |> IO.inspect(limit: :infinity)
      end)

    {
      :reply,
      :ok,
      state
      |> Map.put(
        :rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy,
        rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy
      )
    }
  end

  def handle_call(:generate_rule_activations, _from, %{rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings: rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings,
        rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy: rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy} = state) do
    rule_activations = []

    
    
    {
      :reply,
      :ok,
      state
      |> Map.put(:rule_activations, rule_activations)
    }
  end

  def handle_call(
        :get_rules_filtered_by_lhs_and_asserted_fact_template_names,
        _from,
        %{
          rules_filtered_by_lhs_and_asserted_fact_template_names:
            get_rules_filtered_by_lhs_and_asserted_fact_template_names
        } = state
      ) do
    {
      :reply,
      {
        :ok,
        get_rules_filtered_by_lhs_and_asserted_fact_template_names
      },
      state
    }
  end

  def handle_call(
        :get_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings,
        _from,
        %{
          rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings:
            rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings
        } = state
      ) do
    {
      :reply,
      {
        :ok,
        rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings
      },
      state
    }
  end

  def handle_call(
        :get_rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy,
        _from,
        %{
          rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy:
            rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy
        } = state
      ) do
    {
      :reply,
      {
        :ok,
        rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy
      },
      state
    }
  end

  def handle_call(:get_rule_activations, _from, %{rule_activations: rule_activations} = state) do
    {
      :reply,
      {
        :ok,
        rule_activations
      },
      state
    }
  end

  def start(params) do
    GenServer.start_link(__MODULE__, params)
  end

  def init(facts: facts, rules: rules, mapper: mapper) do
    {
      :ok,
      %{
        facts: facts,
        rules: rules,
        mapper: mapper,
        rules_filtered_by_lhs_and_asserted_fact_template_names: [],
        rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings: [],
        rules_filtered_by_rule_lhs_and_asserted_fact_multiplicy: [],
        rule_activations: []
      }
    }
  end
end
