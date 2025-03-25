defmodule Talisman.Facts do
   alias Talisman.Fact
   
  def assert(server, fact_template) do
    GenServer.call(server, {:assert, fact_template})
  end
  
#  def retract ...
#  def update ...

  def handle_call({:assert, %fact_template_name{} = fact_template}, _from, %{facts_supervisor: facts_supervisor, facts: facts} = state) do

    asserted_fact_identity = "#{fact_template_name}->#{DateTime.utc_now(:microsecond)}"

    updated_facts = %{
      id: asserted_fact_identity,
      start: {
        Fact,
        :start,
        [
          fact_template,
          asserted_fact_identity
        ]
      }
    }
    |> then(fn asserted_fact_child_spec -> DynamicSupervisor.start_child(facts_supervisor, asserted_fact_child_spec) end)
    |> then(fn {_, asserted_fact_pid} -> Map.put(facts, asserted_fact_identity, asserted_fact_pid) end)

    {
      :reply,
      :ok,
      state
      |> Map.put(:facts, updated_facts)
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
