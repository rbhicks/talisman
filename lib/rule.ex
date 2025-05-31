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
    {:ok, active?} = GenServer.call(rule_pid, {:evaluate_lhs_for_asserted_facts, asserted_facts})
    active?
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
        # %{evaluate_lhs_function_args: evaluate_lhs_function_args,
        #   evaluate_lhs_function: evaluate_lhs_function} = state
        %{rule_name: rule_name, get_rule_lhs_evaluation_and_rhs_execution_functions: get_rule_lhs_evaluation_and_rhs_execution_functions} = state
      ) do
    #    use apply/2 with lhs_fact_template_names

    # {_, asserted_fact_pid} = asserted_facts
    # |> List.first
    # |> List.first

    # fact_instance = Fact.get_fact_instance(asserted_fact_pid)
    
    # {lhs_evaluation_function, rhs_execution_function} = get_rule_lhs_evaluation_and_rhs_execution_functions.(fact_instance)

    for closure_function_fact_params <- asserted_facts do
      "m8v823x0ks6d9eh23j4v9u8uyy7w9t" |> IO.puts
      "m8v823x0ks6d9eh23j4v9u8uyy7w9t" |> IO.puts
      "m8v823x0ks6d9eh23j4v9u8uyy7w9t" |> IO.puts
      rule_name |> IO.inspect(limit: :infinity)
      "==============================" |> IO.puts
      params = for {_, asserted_fact_pid} <- closure_function_fact_params do
#        apply(get_rule_lhs_evaluation_and_rhs_execution_functions, Fact.get_fact_instance(asserted_fact_pid))
        Fact.get_fact_instance(asserted_fact_pid)
      end

      
      get_rule_lhs_evaluation_and_rhs_execution_functions
      |> Function.info()
      |> Keyword.get(:arity)
      |> IO.inspect(limit: :infinity)
      "==============================" |> IO.puts
      params |> IO.inspect(limit: :infinity)
      "==============================" |> IO.puts
      {lhs_evaluation_function, rhs_execution_function} = apply(get_rule_lhs_evaluation_and_rhs_execution_functions, params)
#      |> IO.inspect(limit: :infinity)
      "==============================" |> IO.puts
#      asserted_facts |> IO.inspect(limit: :infinity)
      # "==============================" |> IO.puts
      # asserted_fact_pid |> IO.inspect(limit: :infinity)
      # "==============================" |> IO.puts
      # fact_instance |> IO.inspect(limit: :infinity)
      # "==============================" |> IO.puts
      lhs_evaluation_function.() |> IO.inspect(limit: :infinity)
      "==============================" |> IO.puts
      rhs_execution_function.() |> IO.inspect(limit: :infinity)
      "uwa901j4uhb4aadmocdrbg1w9hmqez" |> IO.puts
      "uwa901j4uhb4aadmocdrbg1w9hmqez" |> IO.puts
      "uwa901j4uhb4aadmocdrbg1w9hmqez" |> IO.puts
    end
    active? = false
    
    #    evaluate_lhs_function.(asserted_facts)

    {
      :reply,
      {
        :ok,
        active?
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
        lhs_fact_template_names, lhs_fact_multiplicity,
        get_rule_lhs_evaluation_and_rhs_execution_functions
      },
      name: {:global, rule_name}
    )
  end

  def init(
        # {lhs_fact_template_names, lhs_fact_multiplicity, evaluate_lhs_function_args,
        #  evaluate_lhs_function, execute_rule_function}
        {rule_name,
          lhs_fact_template_names, lhs_fact_multiplicity,
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
        get_rule_lhs_evaluation_and_rhs_execution_functions: get_rule_lhs_evaluation_and_rhs_execution_functions
      }
    }
  end
end
