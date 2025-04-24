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

  def generate_stage_two_candidate_rules(server) do
    :ok = GenServer.call(server, :generate_stage_two_candidate_rules)
  end

  def get_stage_one_candidate_rules(server) do
    {:ok, stage_one_candidate_rules} = GenServer.call(server, :get_stage_one_candidate_rules)
    stage_one_candidate_rules
  end

  def get_stage_two_candidate_rules(server) do
    {:ok, stage_two_candidate_rules} = GenServer.call(server, :get_stage_two_candidate_rules)
    stage_two_candidate_rules
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

  def handle_call(:generate_stage_two_candidate_rules, _from, %{facts: facts, rules: rules, stage_one_candidate_rules: stage_one_candidate_rules, mapper: mapper} = state) do
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # woeful duplication or effort, recalculation,
    # inefficiency, etc. get it working and then consolidate
    # all the stage calculations
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    fact_template_name_to_asserted_facts_mapping = Mapper.get_fact_template_name_to_asserted_facts_mapping(mapper)
    fact_template_to_rule_lhs_mapping = Mapper.get_fact_template_name_to_rule_lhs_mapping(mapper)
    asserted_fact_templates_names = for {_, {asserted_fact_template_name, _}} <- Facts.get_asserted_facts(facts) do
      asserted_fact_template_name
    end
    rule_lhs_fact_template_names = for {_, {rule_name, rule_pid}} <- rules |> Rules.get_rules do
      {rule_name, rule_pid |> Rule.get_lhs_fact_template_names |> MapSet.new}
    end


    "§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§" |> IO.puts
    "§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§" |> IO.puts
    "§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§" |> IO.puts
    rule_lhs_fact_template_names |> IO.inspect(limit: :infinity)
    "=======================================================" |> IO.puts
    asserted_fact_templates_names |> IO.inspect(limit: :infinity)
    "=======================================================" |> IO.puts
    stage_one_candidate_rules |> IO.inspect(limit: :infinity)
    "=======================================================" |> IO.puts
    fact_template_to_rule_lhs_mapping |> IO.inspect(limit: :infinity)
    "=======================================================" |> IO.puts
    fact_template_name_to_asserted_facts_mapping |> IO.inspect(limit: :infinity)
    "±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±" |> IO.puts
    "±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±" |> IO.puts
    "±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±" |> IO.puts
    
    stage_two_candidate_rules = nil
    {
      :reply,
      :ok,
      state
      |> Map.put(:stage_two_candidate_rules, stage_two_candidate_rules)
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

  def handle_call(:get_stage_two_candidate_rules, _from, %{stage_two_candidate_rules: stage_two_candidate_rules} = state) do
    {
      :reply,
      {
        :ok,
        stage_two_candidate_rules
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
         stage_one_candidate_rules: [],
         stage_two_candidate_rules: []
       }
    }
  end
end
