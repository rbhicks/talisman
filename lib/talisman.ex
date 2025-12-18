defmodule Talisman do
  @moduledoc """
  Documentation for `Talisman`.
  """

  use Application

  alias Talisman.TalismanDynamicSupervisor
  alias Talisman.Mapper
  alias Talisman.Facts
  alias Talisman.Rules
  alias Talisman.InferenceEngine
  alias Talisman.Rule

  def start(_type, _args) do    
    children = [
      Talisman.TalismanDynamicSupervisor,
      {Registry, keys: :unique, name: Talisman.Registry}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  ####################################################################
  ####################################################################
  ####################################################################
  ########################### client API #############################
  ####################################################################
  ####################################################################
  ####################################################################

  def create_talisman_instance(name_prefix) do

    facts_supervisor_name = name_prefix <> "_facts_supervisor"
    |> String.to_atom()
    rules_supervisor_name = name_prefix <> "_rules_supervisor"
    |> String.to_atom()
    mapper_name = name_prefix <> "_mapper"
    |> String.to_atom()
    inference_engine_name = name_prefix <> "_inference_engine"
    |> String.to_atom()
    facts_name = name_prefix <> "_facts"
    |> String.to_atom()
    rules_name = name_prefix <> "_rules"
    |> String.to_atom()
    
    
    facts_supervisor_child_spec = 
      %{
        id: facts_supervisor_name,
        start: {
          DynamicSupervisor,
          :start_link,
          [[name: facts_supervisor_name]]
        }
      }

    rules_supervisor_child_spec =
      %{
        id: rules_supervisor_name,
        start: {
          DynamicSupervisor,
          :start_link,
          [[name: rules_supervisor_name]]
        }
      }

    mapper_child_spec =
      %{
        id: mapper_name,
        start: {
          Mapper,
          :start,
          []
        }
      }

    inference_engine_child_spec =
      %{
        id: inference_engine_name,
        start: {
          InferenceEngine,
          :start,
          []
        }
      }

    facts_child_spec =
      %{
        id: facts_name,
        start: {
          Facts,
          :start,
          []
        }
      }

    rules_child_spec =
      %{
        id: rules_name,
        start: {
          Rules,
          :start,
          []
        }
      }

    {:ok, facts_supervisor_pid} =
      TalismanDynamicSupervisor.start_talisman_genserver(facts_supervisor_child_spec)

    {:ok, rules_supervisor_pid} =
      TalismanDynamicSupervisor.start_talisman_genserver(rules_supervisor_child_spec)

    {:ok, mapper_pid} = TalismanDynamicSupervisor.start_talisman_genserver(mapper_child_spec)

    {:ok, inference_engine_pid} =
      TalismanDynamicSupervisor.start_talisman_genserver(inference_engine_child_spec)

    {:ok, facts_pid} = TalismanDynamicSupervisor.start_talisman_genserver(facts_child_spec)
    {:ok, rules_pid} = TalismanDynamicSupervisor.start_talisman_genserver(rules_child_spec)

    {:ok, _} = Registry.register(Talisman.Registry, facts_supervisor_name, facts_supervisor_pid)
    {:ok, _} = Registry.register(Talisman.Registry, rules_supervisor_name, rules_supervisor_pid)
    {:ok, _} = Registry.register(Talisman.Registry, mapper_name, mapper_pid)
    {:ok, _} = Registry.register(Talisman.Registry, inference_engine_name, inference_engine_pid)
    {:ok, _} = Registry.register(Talisman.Registry, facts_name, facts_pid)
    {:ok, _} = Registry.register(Talisman.Registry, rules_name, rules_pid)

    Facts.set_facts_supervisor(facts_pid, facts_supervisor_pid)
    Facts.set_inference_engine(facts_pid, inference_engine_pid)
    Facts.set_mapper(facts_pid, mapper_pid)

    Rules.set_rules_supervisor(rules_pid, rules_supervisor_pid)
    Rules.set_inference_engine(rules_pid, inference_engine_pid)

    InferenceEngine.set_facts(inference_engine_pid, facts_pid)
    InferenceEngine.set_rules(inference_engine_pid, rules_pid)
    InferenceEngine.set_mapper(inference_engine_pid, mapper_pid)
  end

  def load(inference_engine_id, fact_load_modules) do
    Registry.lookup(Talisman.Registry, inference_engine_id)
    |> hd()
    |> elem(1)
    |> InferenceEngine.load(fact_load_modules)
  end
  
  def compile_rules(rules_id, mapper_id) do
    for {_, {rule_name, rule_pid}} <-
          Rules.get_rules(
            Registry.lookup(Talisman.Registry, rules_id)
            |> hd()
            |> elem(1)
          ) do

      "hw0bc9jd84o4rjavo0m5u0j41v60do" |> IO.puts
      "hw0bc9jd84o4rjavo0m5u0j41v60do" |> IO.puts
      "hw0bc9jd84o4rjavo0m5u0j41v60do" |> IO.puts
      rules_id |> IO.inspect(limit: :infinity)
      "==============================" |> IO.puts
      mapper_id |> IO.inspect(limit: :infinity)
      "==============================" |> IO.puts
      rule_name |> IO.inspect(limit: :infinity)
      "==============================" |> IO.puts
      rule_pid |> IO.inspect(limit: :infinity)
      "dpnly6dsmgm03ug5a02vkkslgkbn3t" |> IO.puts
      "dpnly6dsmgm03ug5a02vkkslgkbn3t" |> IO.puts
      "dpnly6dsmgm03ug5a02vkkslgkbn3t" |> IO.puts
      
      Mapper.add_rule_fact_template_names(
        Registry.lookup(Talisman.Registry, mapper_id)
        |> hd()
        |> elem(1),
        rule_name,
        Rule.get_lhs_fact_template_names(rule_pid)
      )
    end

    Registry.lookup(Talisman.Registry, mapper_id)
    |> hd()
    |> elem(1)
    |> Mapper.create_fact_template_name_to_rule_lhs_mapping()    
  end
  
  def run(inference_engine_id) do
    Registry.lookup(Talisman.Registry, inference_engine_id)
    |> hd()
    |> elem(1)
    |> InferenceEngine.run()
  end

  def clear(inference_engine_id) do
    Registry.lookup(Talisman.Registry, inference_engine_id)
    |> hd()
    |> elem(1)
    |> InferenceEngine.clear()
  end
end
