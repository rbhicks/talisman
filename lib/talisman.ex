defmodule Talisman do
  @moduledoc """
  Documentation for `Talisman`.
  """

  alias Talisman.TalismanDynamicSupervisor
  alias Talisman.Mapper
  alias Talisman.Facts
  alias Talisman.Rules
  alias Talisman.InferenceEngine

  def start(_type, _args) do
    children = [
      Talisman.TalismanDynamicSupervisor,
      {Registry, keys: :unique, name: Talisman.Registry}
    ]

    {:ok, supervisor_id} = Supervisor.start_link(children, strategy: :one_for_one)

    facts_supervisor_child_spec =
      %{
        id: :facts_supervisor,
        start: {
          DynamicSupervisor,
          :start_link,
          [[name: :facts_supervisor]]
        }
      }

    rules_supervisor_child_spec =
      %{
        id: :rules_supervisor,
        start: {
          DynamicSupervisor,
          :start_link,
          [[name: :rules_supervisor]]
        }
      }

    mapper_child_spec =
      %{
        id: :mapper,
        start: {
          Mapper,
          :start,
          []
        }
      }

    inference_engine_child_spec =
      %{
        id: :inference_engine,
        start: {
          InferenceEngine,
          :start,
          []
        }
      }

    facts_child_spec =
      %{
        id: :facts,
        start: {
          Facts,
          :start,
          []
        }
      }

    rules_child_spec =
      %{
        id: :rules,
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

    {:ok, _} = Registry.register(Talisman.Registry, :facts_supervisor, facts_supervisor_pid)
    {:ok, _} = Registry.register(Talisman.Registry, :rules_supervisor, rules_supervisor_pid)
    {:ok, _} = Registry.register(Talisman.Registry, :mapper, mapper_pid)
    {:ok, _} = Registry.register(Talisman.Registry, :inference_engine, inference_engine_pid)
    {:ok, _} = Registry.register(Talisman.Registry, :facts, facts_pid)
    {:ok, _} = Registry.register(Talisman.Registry, :rules, rules_pid)

    Facts.set_facts_supervisor(facts_pid, facts_supervisor_pid)
    Facts.set_inference_engine(facts_pid, inference_engine_pid)
    Facts.set_mapper(facts_pid, mapper_pid)

    Rules.set_rules_supervisor(rules_pid, rules_supervisor_pid)
    Rules.set_inference_engine(rules_pid, inference_engine_pid)

    InferenceEngine.set_facts(inference_engine_pid, facts_pid)
    InferenceEngine.set_rules(inference_engine_pid, rules_pid)
    InferenceEngine.set_mapper(inference_engine_pid, mapper_pid)

    {:ok, supervisor_id}
  end

  ####################################################################
  ####################################################################
  ####################################################################
  ########################### client API #############################
  ####################################################################
  ####################################################################
  ####################################################################

  def load(fact_load_modules) do
    Registry.lookup(Talisman.Registry, :inference_engine)
    |> hd()
    |> elem(1)
    |> InferenceEngine.load(fact_load_modules)
  end
  
  def compile_rules(rule_compile_modules) do
    Registry.lookup(Talisman.Registry, :inference_engine)
    |> hd()
    |> elem(1)
    |> InferenceEngine.load(rule_compile_modules)
  end
  
  def run() do
    Registry.lookup(Talisman.Registry, :inference_engine)
    |> hd()
    |> elem(1)
    |> InferenceEngine.run()
  end

  def clear() do
    Registry.lookup(Talisman.Registry, :inference_engine)
    |> hd()
    |> elem(1)
    |> InferenceEngine.clear()
  end
end
