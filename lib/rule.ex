defmodule Talisman.Rule do
  use GenServer

  alias Talisman.Utilities

  def get_lhs_fact_template_names(rule_pid) do
    {:ok, lhs_fact_template_names} = GenServer.call(rule_pid, :get_lhs_fact_template_names)
    lhs_fact_template_names
  end

  def get_lhs_fact_multiplicity(rule_pid) do
    {:ok, lhs_fact_multiplicity} = GenServer.call(rule_pid, :get_lhs_fact_multiplicity)
    lhs_fact_multiplicity
  end

  def add_fact_id(fact_id) do
    {:ok}
  end

  def evaluate_lhs_for_fact_instances do
    {:ok, []}
  end

  def execute_rule do
    {:ok}
  end

  def handle_call(
        :get_lhs_fact_template_names,
        _from,
        {lhs_fact_template_names, _, _, _, _} = state
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

  def handle_call(:get_lhs_fact_multiplicity, _from, {_, lhs_fact_multiplicity, _, _, _} = state) do
    {
      :reply,
      {
        :ok,
        lhs_fact_multiplicity
      },
      state
    }
  end

  def start(
        rule_name,
        lhs_fact_template_names,
        lhs_fact_multiplicity,
        evaluate_lhs_function,
        execute_rule_function
      ) do
    GenServer.start_link(
      __MODULE__,
      {lhs_fact_template_names, lhs_fact_multiplicity, evaluate_lhs_function,
       execute_rule_function},
      name: {:global, rule_name}
    )
  end

  def init(
        {lhs_fact_template_names, lhs_fact_multiplicity, evaluate_lhs_function,
         execute_rule_function}
      ) do
    {
      :ok,
      {
        lhs_fact_template_names,
        lhs_fact_multiplicity,
        evaluate_lhs_function,
        execute_rule_function,
        []
      }
    }
  end
end
