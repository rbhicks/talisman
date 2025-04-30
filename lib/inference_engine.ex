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

  def generate_stage_two_candidate_rule_info(server) do
    :ok = GenServer.call(server, :generate_stage_two_candidate_rule_info)
  end

  def generate_stage_three_candidate_rules(server) do
    :ok = GenServer.call(server, :generate_stage_three_candidate_rules)
  end
  
  def get_stage_one_candidate_rules(server) do
    {:ok, stage_one_candidate_rules} = GenServer.call(server, :get_stage_one_candidate_rules)
    stage_one_candidate_rules
  end

  def get_stage_two_candidate_rule_info(server) do
    {:ok, stage_two_candidate_rule_info} = GenServer.call(server, :get_stage_two_candidate_rule_info)
    stage_two_candidate_rule_info
  end

  def get_stage_three_candidate_rules(server) do
    {:ok, stage_three_candidate_rules} = GenServer.call(server, :get_stage_three_candidate_rules)
    stage_three_candidate_rules
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
    |> Enum.uniq()
    {
      :reply,
      :ok,
      state
      |> Map.put(:stage_one_candidate_rules, stage_one_candidate_rules)
    }
  end

  def handle_call(:generate_stage_two_candidate_rule_info, _from, %{facts: facts, rules: rules, stage_one_candidate_rules: stage_one_candidate_rules, mapper: mapper} = state) do
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
    
    fact_template_name_to_asserted_facts_mapping = Mapper.get_fact_template_name_to_asserted_facts_mapping(mapper)
    fact_template_to_rule_lhs_mapping = Mapper.get_fact_template_name_to_rule_lhs_mapping(mapper)
    asserted_fact_templates_names = for {_, {asserted_fact_template_name, _}} <- Facts.get_asserted_facts(facts) do
      asserted_fact_template_name
    end    
    stage_two_candidate_rule_info = rules
    |> Rules.get_rules
    |> Enum.filter(fn {_, {rule_name, _rule_pid}} ->
      stage_one_candidate_rules |> Enum.member?(rule_name)
    end)
    |> Enum.reduce([], fn {_, {rule_name, rule_pid}}, acc ->

      rule_info = {rule_name, rule_pid, Rule.get_lhs_fact_template_names(rule_pid)}
      
      [rule_info|acc]
    end)
    |> Enum.filter(fn {rule_name, rule_pid, rule_lhs_fact_template_names} ->
      rule_lhs_fact_template_names
      |> Enum.reduce_while(true, fn rule_lhs_fact_template_name, acc ->
        if(Map.has_key?(fact_template_name_to_asserted_facts_mapping, rule_lhs_fact_template_name)) do
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
        }|acc]
    end)
    {
      :reply,
      :ok,
      state
      |> Map.put(:stage_two_candidate_rule_info, stage_two_candidate_rule_info)
    }
  end

  def handle_call(:generate_stage_three_candidate_rules, _from,
    %{
      facts: facts,
      rules: rules,
      stage_one_candidate_rules: stage_one_candidate_rules,
      stage_two_candidate_rule_info: stage_two_candidate_rule_info
    } = state) do

    asserted_facts = Facts.get_asserted_facts(facts)
    current_rules = Rules.get_rules(rules)
    "()()()()()()()()()()()()()()()()()()()()()()()(()()()()" |> IO.puts
    "()()()()()()()()()()()()()()()()()()()()()()()(()()()()" |> IO.puts
    "()()()()()()()()()()()()()()()()()()()()()()()(()()()()" |> IO.puts
    asserted_facts |> IO.inspect(limit: :infinity)
    "=======================================================" |> IO.puts
    current_rules |> IO.inspect(limit: :infinity)
    "=======================================================" |> IO.puts
    stage_one_candidate_rules |> IO.inspect(limit: :infinity)
    "=======================================================" |> IO.puts
    # stage_two_candidate_rule_info |> IO.inspect(limit: :infinity)
    # "=======================================================" |> IO.puts
    # stage_two_candidate_rule_info
    # |> Enum.filter(fn {_, rule_pid, _} ->
    #   "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
    #   "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
    #   "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
    #   rule_pid
    #   |> Rule.get_lhs_fact_multiplicity()
    #   |> IO.inspect(limit: :infinity)
    #   "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" |> IO.puts
    #   "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" |> IO.puts
    #   "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" |> IO.puts
    # end)
    asserted_facts_template_name_frequencies = asserted_facts
    |> Map.values()
    |> Enum.map(fn {asserted_fact_template_name, _} ->
      asserted_fact_template_name
    end)
    |> Enum.frequencies()

    stage_three_candidate_rules = current_rules
    |> Map.take(stage_one_candidate_rules)
    |> Enum.filter(fn {_, {rule_name, rule_pid}} ->
      lhs_fact_multiplicity = Rule.get_lhs_fact_multiplicity(rule_pid)
      lhs_fact_multiplicity
      |> Enum.reduce_while(true, fn {lhs_fact_template_name, lhs_fact_template_name_multiplicity}, acc ->
        if(Map.get(asserted_facts_template_name_frequencies, lhs_fact_template_name) >= lhs_fact_template_name_multiplicity) do
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
      |> Map.put(:stage_three_candidate_rules, stage_three_candidate_rules)
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

  def handle_call(:get_stage_two_candidate_rule_info, _from, %{stage_two_candidate_rule_info: stage_two_candidate_rule_info} = state) do
    {
      :reply,
      {
        :ok,
        stage_two_candidate_rule_info
      },
      state
    }
  end

  def handle_call(:get_stage_three_candidate_rules, _from, %{stage_three_candidate_rules: stage_three_candidate_rules} = state) do
    {
      :reply,
      {
        :ok,
        stage_three_candidate_rules
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
         stage_two_candidate_rule_info: [],
         stage_three_candidate_rules: []
       }
    }
  end
end
