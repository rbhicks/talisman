defmodule Talisman.Rule do
  use GenServer

  alias Talisman.Fact

  def get_lhs_fact_template_names(rule_pid) do
    {:ok, lhs_fact_template_names} = GenServer.call(rule_pid, :get_lhs_fact_template_names)
    lhs_fact_template_names
  end

  def get_lhs_fact_multiplicity(rule_pid) do
    {:ok, lhs_fact_multiplicity} = GenServer.call(rule_pid, :get_lhs_fact_multiplicity)
    lhs_fact_multiplicity
  end

  def evaluate_lhs_for_asserted_facts(rule_pid, asserted_facts) do
    {:ok, activations} =
      GenServer.call(rule_pid, {:evaluate_lhs_for_asserted_facts, asserted_facts})

    activations
  end

  def add_asserted_lhs_fact(server, lhs_fact_name, lhs_fact) do
    GenServer.call(server, {:add_asserted_lhs_fact, lhs_fact_name, lhs_fact}, 10000)
  end

  def get_activations(server) do
    {:ok, activations} = GenServer.call(server, :get_activations, 10000)
    activations
  end

  def get_asserted_lhs_facts(server) do
    {:ok, asserted_lhs_facts} = GenServer.call(server, :get_asserted_lhs_facts)
    asserted_lhs_facts
  end

  #########################################################################
  #########################################################################
  #########################################################################

  def handle_call(
        :get_lhs_fact_template_names,
        _from,
        %{lhs_fact_template_names: lhs_fact_template_names} = state
      ) do
    {
      :reply,
      {
        :ok,
        lhs_fact_template_names
      },
      state
    }
  end

  def handle_call(
        :get_lhs_fact_multiplicity,
        _from,
        %{lhs_fact_multiplicity: lhs_fact_multiplicity} = state
      ) do
    {
      :reply,
      {
        :ok,
        lhs_fact_multiplicity
      },
      state
    }
  end

  def handle_call(
        {:evaluate_lhs_for_asserted_facts, asserted_facts},
        _from,
        %{
          get_rule_lhs_evaluation_and_rhs_execution_functions:
            get_rule_lhs_evaluation_and_rhs_execution_functions
        } = state
      ) do
    activations =
      for closure_function_param_info <- asserted_facts do
        [closure_function_params, asserted_fact_pids] =
          closure_function_param_info
          |> Enum.reduce([[], []], fn {_, asserted_fact_pid},
                                      [asserted_fact_instances, asserted_fact_pids] ->
            [
              [Fact.get_fact_instance(asserted_fact_pid) | asserted_fact_instances]
              | [[asserted_fact_pid | asserted_fact_pids]]
            ]
          end)

        closure_function_params = Enum.reverse(closure_function_params)
        asserted_fact_pids = Enum.reverse(asserted_fact_pids)

        {lhs_evaluation_function, rhs_execution_function} =
          apply(get_rule_lhs_evaluation_and_rhs_execution_functions, closure_function_params)

        {
          asserted_fact_pids,
          lhs_evaluation_function,
          rhs_execution_function
        }
      end
      |> Enum.filter(fn {_, lhs_evaluation_function, _} ->
        lhs_evaluation_function.()
      end)
      |> Enum.map(fn {asserted_fact_pids, _, rhs_execution_function} ->
        {
          asserted_fact_pids,
          rhs_execution_function
        }
      end)
    {
      :reply,
      {
        :ok,
        activations
      },
      state
    }
  end

  def handle_call(
    {:add_asserted_lhs_fact, lhs_fact_name, lhs_fact},
        _from,
        %{
          asserted_lhs_facts: asserted_lhs_facts,
          lhs_fact_template_names: lhs_fact_template_names,
          get_rule_lhs_evaluation_and_rhs_execution_functions:
            get_rule_lhs_evaluation_and_rhs_execution_functions
        } = state
      ) do
    
    updated_asserted_lhs_facts = update_asserted_lhs_facts(lhs_fact_name, lhs_fact, asserted_lhs_facts)
    activations = generate_activations(updated_asserted_lhs_facts, lhs_fact_template_names, get_rule_lhs_evaluation_and_rhs_execution_functions)    
    {
      :reply,
      :ok,
      state
      |> Map.put(:asserted_lhs_facts, updated_asserted_lhs_facts)
      |> Map.put(:activations, activations)
    }
  end

  def handle_call(
    :get_activations,
        _from,
        %{activations: activations} = state
      ) do
    {
      :reply,
      {:ok, activations},
      state
      |> Map.put(:activations, [])
    }
  end

  def handle_call(
    :get_asserted_lhs_facts,
        _from,
        %{asserted_lhs_facts: asserted_lhs_facts} = state
      ) do
    {
      :reply,
      {:ok, asserted_lhs_facts},
      state
    }
  end

  #########################################################################
  #########################################################################
  #########################################################################
  
  def start(
        rule_name,
        lhs_fact_template_names,
        lhs_fact_multiplicity,
        get_rule_lhs_evaluation_and_rhs_execution_functions
      ) do
    GenServer.start_link(
      __MODULE__,
      {
        rule_name,
        lhs_fact_template_names,
        lhs_fact_multiplicity,
        get_rule_lhs_evaluation_and_rhs_execution_functions
      },
      name: {:global, rule_name}
    )
  end

  def init(
        {rule_name, lhs_fact_template_names, lhs_fact_multiplicity,
         get_rule_lhs_evaluation_and_rhs_execution_functions}
      ) do
    {
      :ok,
      %{
        rule_name: rule_name,
        lhs_fact_template_names: lhs_fact_template_names,
        lhs_fact_multiplicity: lhs_fact_multiplicity,
        get_rule_lhs_evaluation_and_rhs_execution_functions:
          get_rule_lhs_evaluation_and_rhs_execution_functions,
        asserted_lhs_facts: %{},
        activations: []
      }
    }
  end

  #########################################################################
  #########################################################################
  #########################################################################

  def generate_activations(asserted_lhs_facts, lhs_fact_template_names, get_rule_lhs_evaluation_and_rhs_execution_functions) do

    candidate_activations = lhs_fact_template_names
    |> Enum.map(fn lhs_fact_template_name ->
      asserted_lhs_facts
      |> Map.get(lhs_fact_template_name)
    end)

    if(not Enum.member?(candidate_activations, nil)) do
      create_lhs_facts_sets(candidate_activations)
      |> Enum.reduce([], fn lhs_fact_set, acc ->
        {lhs_evaluation_function, rhs_execution_function} =
          apply(get_rule_lhs_evaluation_and_rhs_execution_functions, lhs_fact_set)

        if(lhs_evaluation_function.()) do
          [rhs_execution_function|acc]
        else
          acc
        end
      end)
    else
      []
    end
  end

  def update_asserted_lhs_facts(lhs_fact_name, lhs_fact, asserted_lhs_facts) do
    if(Map.has_key?(asserted_lhs_facts, lhs_fact_name)) do
      asserted_lhs_facts
      |> Map.put(lhs_fact_name, [lhs_fact|Map.get(asserted_lhs_facts, lhs_fact_name)])
    else
      asserted_lhs_facts
      |> Map.put(lhs_fact_name, [lhs_fact])
    end
  end

  def create_lhs_facts_sets([]), do: [[]]
  def create_lhs_facts_sets([head | tail]) do
      for item <- head, rest <- create_lhs_facts_sets(tail) do
        [item | rest]
      end
  end

  def get_fact_template_name_multiplicities(lhs_fact_multiplicity) do
    lhs_fact_multiplicity
    |> Enum.map(fn {{_, _, module_path}, _value} ->
      module_path
      |> List.last()
    end)
    |> Enum.frequencies()
  end
end
