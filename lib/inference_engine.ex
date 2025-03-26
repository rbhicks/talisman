defmodule Talisman.InferenceEngine do
  use GenServer

  alias Talisman.Rule
  alias Talisman.Rules
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
  def generate_fact_template_name_hashes_powerset(server) do
    {:ok, fact_template_name_hashes_powerset} = GenServer.call(server, :generate_fact_template_name_hashes_powerset)
    fact_template_name_hashes_powerset
  end

  def handle_call(:generate_fact_template_name_hashes_powerset, _from, %{rules: rules} = state) do    
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

  def start(rules) do
    GenServer.start_link(__MODULE__, rules)
  end
  
  def init([rules: rules]) do
    {
      :ok,
       %{
         rules: rules
       }
    }
  end
end
