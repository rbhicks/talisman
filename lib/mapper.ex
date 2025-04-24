defmodule Talisman.Mapper do
  use GenServer

  # @moduledoc """
  # fact templates can be added from the
  # rules, instead of a separate enumeration
  # because should a fact template not be
  # referenced by a rule, it's pointless
  # (should be pruned anyway)
  # """
  
  # @doc """
  # a batch version can be created later if needed
  # """
  def add_rule_fact_template_names(server, rule_name, rule_fact_template_names) do
    GenServer.call(server, {:add_rule_fact_template_names, rule_name, rule_fact_template_names})
  end

  def create_fact_template_name_to_rule_lhs_mapping(server) do
    GenServer.call(server, :create_fact_template_name_to_rule_lhs_mapping)
  end

  def get_fact_template_name_to_rule_lhs_mapping(server) do
    {:ok, fact_template_name_to_rule_lhs_mapping} = GenServer.call(server, :get_fact_template_name_to_rule_lhs_mapping)
    fact_template_name_to_rule_lhs_mapping
  end

  def handle_call(
    {:add_rule_fact_template_names, rule_name, rule_fact_template_names},
    _from,
    %{
      fact_template_names: current_fact_template_names,
      rule_fact_template_names: current_rule_fact_template_names
    }
  ) do
    {
      :reply,
      :ok,
      %{
        fact_template_names: current_fact_template_names
        |> MapSet.to_list()
        |> Enum.concat(rule_fact_template_names)
        |> MapSet.new(),
        rule_fact_template_names: [{rule_name, rule_fact_template_names}|current_rule_fact_template_names],
        fact_template_name_to_rule_lhs_mapping: %{}
      }
    }
  end

  def handle_call(
    :create_fact_template_name_to_rule_lhs_mapping,
    _from,
    %{fact_template_names: fact_template_names, rule_fact_template_names: rule_fact_template_names} = state) do
    fact_template_name_to_rule_lhs_mapping = fact_template_names
    |> MapSet.to_list()
    |> Enum.reduce(%{}, fn fact_template_name, acc ->
      acc
      |> Map.put(
        fact_template_name, 
        rule_fact_template_names
        |> Enum.reduce([], fn {rule_name, current_rule_fact_template_names}, acc ->
          if Enum.member?(current_rule_fact_template_names, fact_template_name) do
            [rule_name|acc]
          else
            acc
          end
        end)
      )
    end)    
    {
      :reply,
      :ok,
      Map.put(state, :fact_template_name_to_rule_lhs_mapping, fact_template_name_to_rule_lhs_mapping)
    }
  end

  def handle_call(
    :get_fact_template_name_to_rule_lhs_mapping,
    _from,
    %{fact_template_name_to_rule_lhs_mapping: fact_template_name_to_rule_lhs_mapping} = state) do
    {
      :reply,
      {:ok, fact_template_name_to_rule_lhs_mapping},
      state
    }
  end
      
  def start() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {
      :ok,
       %{fact_template_names: MapSet.new(), rule_fact_template_names: []}
    }
  end
end
