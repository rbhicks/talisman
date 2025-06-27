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
    GenServer.call(server, :set_run_in_progress)
    filter_rules_by_rule_lhs_and_asserted_fact_template_names(server)

    generate_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings(server)

    filter_rules_by_rule_lhs_and_asserted_fact_multiplicity(server)
    generate_candidate_rule_activations(server)
    generate_activated_rules(server)
    execute_activated_rules(server)

    GenServer.call(server, :clear_run_in_progress)
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

  def filter_rules_by_rule_lhs_and_asserted_fact_multiplicity(server) do
    :ok = GenServer.call(server, :filter_rules_by_rule_lhs_and_asserted_fact_multiplicity)
  end

  def generate_candidate_rule_activations(server) do
    :ok = GenServer.call(server, :generate_candidate_rule_activations)
  end

  def generate_activated_rules(server) do
    :ok = GenServer.call(server, :generate_activated_rules)
  end

  def execute_activated_rules(server) do
    :ok = GenServer.call(server, :execute_activated_rules)
  end

  def notify_fact_assertion(server, fact_pid) do
    # GenServer.call(server, {:notify_fact_assertion, fact_pid})
    GenServer.cast(server, {:notify_fact_assertion, fact_pid})
  end

  def notify_fact_retraction(server, fact_pid) do
    GenServer.call(server, {:notify_fact_retraction, fact_pid})
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

  def get_rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity(server) do
    {:ok, rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity} =
      GenServer.call(server, :get_rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity)

    rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity
  end

  def get_candidate_rule_activations(server) do
    {:ok, candidate_rule_activations} = GenServer.call(server, :get_candidate_rule_activations)
    candidate_rule_activations
  end

  def get_activated_rules(server) do
    {:ok, activated_rules} = GenServer.call(server, :get_activated_rules)
    activated_rules
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
        :filter_rules_by_rule_lhs_and_asserted_fact_multiplicity,
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

    rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity =
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

    {
      :reply,
      :ok,
      state
      |> Map.put(
        :rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity,
        rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity
      )
    }
  end

  def handle_call(
        :generate_candidate_rule_activations,
        _from,
        %{
          rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings:
            rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings,
          rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity:
            rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity
        } = state
      ) do
    candidate_rule_activations =
      for {mapping_rule_name, _, _} = mapping <-
            rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings,
          {_, {rule_name, _}} <- rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity,
          mapping_rule_name == rule_name do
        mapping
      end

    {
      :reply,
      :ok,
      state
      |> Map.put(:candidate_rule_activations, candidate_rule_activations)
    }
  end

  def handle_call(
        :generate_activated_rules,
        _from,
        %{candidate_rule_activations: candidate_rule_activations} = state
      ) do
    activated_rules =
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

    {
      :reply,
      :ok,
      state
      |> Map.put(:activated_rules, activated_rules)
    }
  end

  def handle_call(
        :execute_activated_rules,
        _from,
        %{activated_rules: activated_rules} = state
      ) do
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

  def handle_cast({:notify_fact_assertion, fact_pid}, %{run_in_progess: true} = state) do
    {
      :noreply,
      state
    }
  end

  def handle_cast({:notify_fact_assertion, fact_pid}, %{run_in_progess: false} = state) do
    {
      :noreply,
      state
    }
  end

  def handle_call(:set_run_in_progress, _, state) do
    {
      :reply,
      :ok,
      state
      |> Map.put(:run_in_progress, true)
    }
  end

  def handle_call(:clear_run_in_progress, _, state) do
    {
      :reply,
      :ok,
      state
      |> Map.put(:run_in_progress, false)
    }
  end
  
  def handle_call({:notify_fact_retraction, fact_pid}, _, %{run_in_progess: true} = state) do
    {
      :reply,
      :ok,
      state
    }
  end

  def handle_call({:notify_fact_retraction, fact_pid}, _, %{run_in_progess: false} = state) do
    {
      :reply,
      :ok,
      state
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
        :get_rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity,
        _from,
        %{
          rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity:
            rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity
        } = state
      ) do
    {
      :reply,
      {
        :ok,
        rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity
      },
      state
    }
  end

  def handle_call(
        :get_candidate_rule_activations,
        _from,
        %{candidate_rule_activations: candidate_rule_activations} = state
      ) do
    {
      :reply,
      {
        :ok,
        candidate_rule_activations
      },
      state
    }
  end

  def handle_call(:get_activated_rules, _from, %{activated_rules: activated_rules} = state) do
    {
      :reply,
      {
        :ok,
        activated_rules
      },
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
        rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity: [],
        candidate_rule_activations: [],
        activated_rules: [],
        run_in_progess: false
      }
    }
  end
end
