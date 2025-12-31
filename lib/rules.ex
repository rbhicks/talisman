defmodule Talisman.Rules do
  use GenServer

  alias Talisman.Rule
  alias Talisman.Utilities

  def set_rules_supervisor(server, rules_supervisor) do
    GenServer.call(server, {:set_rules_supervisor, rules_supervisor})
  end

  def get_rules(server) do
    {:ok, rules} = GenServer.call(server, :get_rules)
    rules
  end

  def add_rule(server, rule_name, rule) do
    GenServer.call(server, {:add_rule, rule_name, rule})
  end

  def create_fact_template_name_to_rule_association(server) do
    GenServer.call(server, :create_fact_template_name_to_rule_association)
  end

  #########################################################################
  #########################################################################
  #########################################################################
  
  def handle_call({:set_rules_supervisor, rules_supervisor}, _, state) do
    {
      :reply,
      :ok,
      state
      |> Map.put(:rules_supervisor, rules_supervisor)
    }
  end

  def handle_call(
        {:add_rule, rule_name, rule},
        _from,
        %{rules_supervisor: rules_supervisor, rules: rules} = state
      ) do
    Utilities.generate_fact_assertion_or_rule_addition_response(
      rules_supervisor,
      %{
        id: rule_name,
        start: {
          Rule,
          :start,
          [
            rule_name,
            rule.lhs_fact_template_names,
            rule.lhs_fact_multiplicity,
            rule.get_rule_lhs_evaluation_and_rhs_execution_functions
          ]
        }
      },
      rules,
      rule_name,
      :rules,
      state
    )
  end

  def handle_call(
        :create_fact_template_name_to_rule_association,
        _from,
        state
      ) do
    {
      :reply,
      :ok,
      state
    }
  end

  def handle_call(:get_rules, _from, %{rules: rules} = state) do
    {
      :reply,
      {:ok, rules},
      state
    }
  end

  #########################################################################
  #########################################################################
  #########################################################################
  
  def start() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {
      :ok,
      %{
        rules_supervisor: nil,
        rules: %{},
        lhs_fact_template_names_to_rule: nil
      }
    }
  end

  #########################################################################
  #########################################################################
  #########################################################################

  
end
