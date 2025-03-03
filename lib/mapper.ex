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
  def add_rule_fact_templates(server, rule_name, rule_fact_templates) do
    GenServer.call(server, {:add_rule_fact_templates, rule_name, rule_fact_templates})
  end

  def create_fact_template_to_rule_lhs_mapping(server) do
    GenServer.call(server, :create_fact_template_to_rule_lhs_mapping)
  end

  def get_fact_template_to_rule_lhs_mapping(server) do
    GenServer.call(server, :get_fact_template_to_rule_lhs_mapping)
  end

  def handle_call(
    {:add_rule_fact_templates, rule_name, rule_fact_templates},
    _from,
    %{
      fact_templates: current_fact_templates,
      rule_fact_templates: current_rule_fact_templates
    }
  ) do
    {
      :reply,
      :ok,
      %{
        fact_templates: current_fact_templates
        |> MapSet.to_list()
        |> Enum.concat(rule_fact_templates)
        |> MapSet.new(),
        rule_fact_templates: [{rule_name, rule_fact_templates}|current_rule_fact_templates],
        fact_template_to_rule_lhs_mapping: %{}
      }
    }
  end

  def handle_call(
    :create_fact_template_to_rule_lhs_mapping,
    _from,
    %{fact_templates: fact_templates, rule_fact_templates: rule_fact_templates} = state) do
    fact_template_to_rule_lhs_mapping = fact_templates
    |> MapSet.to_list()
    |> Enum.reduce(%{}, fn fact_template, acc ->
      acc
      |> Map.put(
        fact_template, 
        rule_fact_templates
        |> Enum.reduce([], fn {rule_name, current_rule_fact_templates}, acc ->
          if Enum.member?(current_rule_fact_templates, fact_template) do
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
      Map.put(state, :fact_template_to_rule_lhs_mapping, fact_template_to_rule_lhs_mapping)
    }
  end

  def handle_call(
    :get_fact_template_to_rule_lhs_mapping,
    _from,
    %{fact_template_to_rule_lhs_mapping: fact_template_to_rule_lhs_mapping} = state) do
    {
      :reply,
      {:ok, fact_template_to_rule_lhs_mapping},
      state
    }
  end
      
  def start() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {
      :ok,
       %{fact_templates: MapSet.new(), rule_fact_templates: []}
    }
  end
end

