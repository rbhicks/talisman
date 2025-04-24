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

  # we pull the fact templates from rules because the necessary fact templates
  # can always be derived from the rules' lhs'. if it were done from a collection
  # of fact templates it could occur that we're process templates that aren't used
  # by rules which are unnecssary. not meally an opetimization, but also reduces
  # complexity by not explicitly tracking fact templates. should this become
  # needed later, we will.
  def generate_lhs_fact_template_name_hashes_powerset(server) do
    {:ok, lhs_fact_template_name_hashes_powerset} = GenServer.call(server, :generate_lhs_fact_template_name_hashes_powerset)
    lhs_fact_template_name_hashes_powerset
  end

  def generate_asserted_facts_template_name_hashes_powerset(server) do
    {:ok, asserted_facts_template_name_hashes_powerset} = GenServer.call(server, :generate_asserted_facts_template_name_hashes_powerset)
    asserted_facts_template_name_hashes_powerset
  end

  def generate_stage_one_candidate_rules(server) do
    :ok = GenServer.call(server, :generate_stage_one_candidate_rules)
  end

  def get_stage_one_candidate_rules(server) do
    {:ok, stage_one_candidate_rules} = GenServer.call(server, :get_stage_one_candidate_rules)
    stage_one_candidate_rules
  end

  def handle_call(:generate_lhs_fact_template_name_hashes_powerset, _from, %{rules: rules} = state) do    
    {
      :reply,
      {
        :ok,
        for {_, {_, rule_pid}} <- Rules.get_rules(rules) do
          Rule.get_lhs_fact_template_names(rule_pid)
        end
        |> Enum.flat_map(fn lhs_fact_template_names -> lhs_fact_template_names end)
        |> Enum.uniq()
        |> Utilities.generate_powerset()
        |> Enum.map(fn fact_template_names_powerset_element ->
          Utilities.generate_fact_template_names_hash(fact_template_names_powerset_element)
        end)
      },
      state}
  end

  def handle_call(:generate_asserted_facts_template_name_hashes_powerset, _from, %{facts: facts} = state) do    
    {
      :reply,
      {
        :ok,
        for {_, {fact_template_name, _}} <- Facts.get_asserted_facts(facts) do
          fact_template_name
        end
        |> Enum.uniq()
        |> Utilities.generate_powerset()
        |> Enum.map(fn fact_template_names_powerset_element ->
          Utilities.generate_fact_template_names_hash(fact_template_names_powerset_element)
        end)
      },
      state}
  end

  def handle_call(:generate_stage_one_candidate_rules, _from, %{facts: facts, rules: rules, mapper: mapper} = state) do
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
    asserted_fact_templates_names = for {_, {asserted_fact_template_name, _}} <- asserted_facts do
      asserted_fact_template_name
    end
    |> MapSet.new
    |> MapSet.to_list
    |> MapSet.new
    rule_lhs_fact_template_names = for {_, {rule_name, rule_pid}} <- rules |> Rules.get_rules do
      {rule_name, rule_pid |> Rule.get_lhs_fact_template_names |> MapSet.new}
    end
    mapped_rules = asserted_fact_templates_names
    |> Enum.filter(fn asserted_fact_template_name ->
      Map.get(fact_template_to_rule_lhs_mapping, asserted_fact_template_name)
    end)
    |> Enum.reduce([], fn asserted_fact_template_name, acc ->
      fact_template_to_rule_lhs_mapping
      |> Map.get(asserted_fact_template_name)
      |> Kernel.++(acc)
    end)
    stage_one_candidate_rules = mapped_rules
    |> Enum.filter(fn rule_name ->
      rule_lhs_fact_template_names[rule_name]
      |> MapSet.subset?(asserted_fact_templates_names)
    end)
    
    {
      :reply,
      :ok,
      state
      |> Map.put(:stage_one_candidate_rules, stage_one_candidate_rules)
    }
  end

  def handle_call(:get_stage_one_candidate_rules, _from, %{stage_one_candidate_rules: stage_one_candidate_rules} = state) do
    {
      :reply,
      {
        :ok,
        stage_one_candidate_rules
      },
      state
    }
  end

  def start(params) do
    GenServer.start_link(__MODULE__, params)
  end
  
  def init([facts: facts, rules: rules, mapper: mapper]) do
    {
      :ok,
       %{
         facts: facts,
         rules: rules,
         mapper: mapper,
         stage_one_candidate_rules: []
       }
    }
  end
end

# defmodule Talisman.InferenceEngine do
#   @moduledoc """
#   Manages Talisman's Rete-inspired inference engine, using ETS for fact template → rules
#   and fact PID → rules mappings. Handles fact assertion/retraction, prunes rule candidates,
#   and notifies rules for evaluation. Designed for a trading system with frequent fact assertions.
#   """
#   use GenServer

#   # Client API
#   def start_link(_opts \\ []) do
#     GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
#   end

#   @doc """
#   Asserts a fact, mapping it to candidate rules based on its template.
#   """
#   def assert_fact(fact_pid, fact_template, fact_data) when is_pid(fact_pid) do
#     GenServer.cast(__MODULE__, {:assert_fact, fact_pid, fact_template, fact_data})
#   end

#   @doc """
#   Retracts a fact, cleaning up its mappings and notifying affected rules.
#   """
#   def retract_fact(fact_pid) when is_pid(fact_pid) do
#     GenServer.cast(__MODULE__, {:retract_fact, fact_pid})
#   end

#   @doc """
#   Adds a rule with its fact template dependencies to the mapping.
#   """
#   def add_rule(rule_id, fact_templates) when is_list(fact_templates) do
#     GenServer.call(__MODULE__, {:add_rule, rule_id, fact_templates})
#   end

#   # Server Callbacks
#   def init(:ok) do
#     # Create ETS tables: :set for unique keys, :public for concurrent access
#     :ets.new(:fact_template_to_rules, [:set, :public, :named_table])
#     :ets.new(:fact_to_rules, [:set, :public, :named_table])
#     {:ok, %{}}
#   end

#   def handle_call({:add_rule, rule_id, fact_templates}, _from, state) do
#     # Map each fact template to the rule, appending to existing rules
#     Enum.each(fact_templates, fn template ->
#       current_rules = :ets.lookup(:fact_template_to_rules, template) |> get_rules()
#       :ets.insert(:fact_template_to_rules, {template, [rule_id | current_rules]})
#     end)
#     {:reply, :ok, state}
#   end

#   def handle_cast({:assert_fact, fact_pid, fact_template, fact_data}, state) do
#     # Monitor fact process for cleanup
#     Process.monitor(fact_pid)

#     # Get candidate rules for the fact template (stage 1 of candidacy)
#     rules = :ets.lookup(:fact_template_to_rules, fact_template) |> get_rules()

#     # Store fact PID → rules mapping for retraction
#     :ets.insert(:fact_to_rules, {fact_pid, rules})

#     # Notify rules (placeholder for stage 2: check LHS conditions)
#     Enum.each(rules, &notify_rule(&1, fact_pid, fact_data))

#     {:noreply, state}
#   end

#   def handle_cast({:retract_fact, fact_pid}, state) do
#     # Clean up fact PID mapping and notify affected rules
#     case :ets.lookup(:fact_to_rules, fact_pid) do
#       [{^fact_pid, rules}] ->
#         :ets.delete(:fact_to_rules, fact_pid)
#         Enum.each(rules, &notify_rule_retraction(&1, fact_pid))
#       _ ->
#         :ok
#     end
#     {:noreply, state}
#   end

#   def handle_info({:DOWN, _ref, :process, fact_pid, _reason}, state) do
#     # Handle fact process crash by retracting it
#     handle_cast({:retract_fact, fact_pid}, state)
#     {:noreply, state}
#   end

#   # Helpers
#   defp get_rules([]), do: []
#   defp get_rules([{_, rules}]), do: rules

#   defp notify_rule(rule_id, fact_pid, fact_data) do
#     # Placeholder: Send fact to rule GenServer for LHS evaluation (stage 2)
#     # In practice, check rule's specific conditions before sending
#     # Example: GenServer.cast(rule_id, {:evaluate_fact, fact_pid, fact_data})
#     :ok
#   end

#   defp notify_rule_retraction(rule_id, fact_pid) do
#     # Placeholder: Notify rule of fact retraction
#     # Example: GenServer.cast(rule_id, {:retract_fact, fact_pid})
#     :ok
#   end
# end


# # Add a rule with fact template dependencies
# Talisman.InferenceEngine.add_rule(:rule1, [[:price, :volume], [:trend]])

# # Assert a fact (fact_pid is a GenServer PID)
# fact_pid = spawn_fact_process() # Your fact GenServer
# Talisman.InferenceEngine.assert_fact(fact_pid, [:price, :volume], %{price: 100, volume: 500})

# # Retract a fact
# Talisman.InferenceEngine.retract_fact(fact_pid)
