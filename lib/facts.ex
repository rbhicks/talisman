defmodule Talisman.Facts do
  use GenServer
  
  alias Talisman.Fact
  alias Talisman.Utilities
  alias Talisman.Mapper
   
  def assert(server, fact_template, mapper) do
    GenServer.call(server, {:assert, fact_template, mapper})
  end
  
#  def retract ...
#  def update ...

  def get_asserted_facts(server) do
    {:ok, asserted_facts} = GenServer.call(server, :get_asserted_facts)

    asserted_facts
  end

  def handle_call({:assert, %fact_template_name{} = fact_template, mapper}, _from, %{facts_supervisor: facts_supervisor, facts: facts} = state) do

    asserted_fact_identity = "#{fact_template_name}->#{DateTime.utc_now(:microsecond)}"

    response = Utilities.generate_fact_assertion_or_rule_addition_response(
      facts_supervisor,
      %{
        id: asserted_fact_identity,
        start: {
          Fact,
          :start,
          [
            fact_template,
            asserted_fact_identity
          ]
        }
      },
      facts,
      fact_template_name,
      :facts,
      state
    )

    {_, {_, pid}, _} = response

    Mapper.update_fact_template_name_asserted_facts_mapping(mapper, fact_template_name, pid)
    
    response
  end

  def handle_call(:get_asserted_facts, _from, %{facts: facts} = state) do
    {
      :reply,
      {:ok, facts},
      state
    }
  end

  def start([facts_supervisor]) do
    GenServer.start_link(__MODULE__, facts_supervisor)
  end
  
  def init({_, facts_supervisor_pid}) do    
    {
      :ok,
       %{
         facts_supervisor: facts_supervisor_pid,
         facts: %{}
       }
    }
  end
end
