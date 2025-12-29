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
          get_rule_lhs_evaluation_and_rhs_execution_functions
      }
    }
  end
end
