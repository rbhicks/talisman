defmodule Talisman.Rule do
  use GenServer

  alias Talisman.Utilities
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
    {:ok, activations} = GenServer.call(rule_pid, {:evaluate_lhs_for_asserted_facts, asserted_facts})
    activations
  end

  def execute_rule do
    {:ok}
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
          rule_name: rule_name,
          get_rule_lhs_evaluation_and_rhs_execution_functions:
            get_rule_lhs_evaluation_and_rhs_execution_functions
        } = state
      ) do
    activations = for closure_function_param_info <- asserted_facts do
      closure_function_params =
        for {_, asserted_fact_pid} <- closure_function_param_info do
          Fact.get_fact_instance(asserted_fact_pid)
        end

      {lhs_evaluation_function, rhs_execution_function} =
        apply(get_rule_lhs_evaluation_and_rhs_execution_functions, closure_function_params)

      {
        rule_name,
        closure_function_params,
        lhs_evaluation_function,
        rhs_execution_function
      }

    end
    |> Enum.filter(fn {_, _, lhs_evaluation_function, _} ->
      lhs_evaluation_function.()
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
        # evaluate_lhs_function_args,
        # evaluate_lhs_function,
        # execute_rule_function
        get_rule_lhs_evaluation_and_rhs_execution_functions
      ) do
    GenServer.start_link(
      __MODULE__,
      # {lhs_fact_template_names, lhs_fact_multiplicity, evaluate_lhs_function_args,
      #  evaluate_lhs_function, execute_rule_function},
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
        # {lhs_fact_template_names, lhs_fact_multiplicity, evaluate_lhs_function_args,
        #  evaluate_lhs_function, execute_rule_function}
        {rule_name, lhs_fact_template_names, lhs_fact_multiplicity,
         get_rule_lhs_evaluation_and_rhs_execution_functions}
      ) do
    {
      :ok,
      %{
        rule_name: rule_name,
        lhs_fact_template_names: lhs_fact_template_names,
        lhs_fact_multiplicity: lhs_fact_multiplicity,
        # evaluate_lhs_function_args: evaluate_lhs_function_args,
        # evaluate_lhs_function: evaluate_lhs_function,
        # execute_rule_function: execute_rule_function
        get_rule_lhs_evaluation_and_rhs_execution_functions:
          get_rule_lhs_evaluation_and_rhs_execution_functions
      }
    }
  end
end
