defmodule Talisman.Facts do
  def assert(server, fact_template_name, fact_template) do
    GenServer.call({:assert, fact_template_name, fact_template})
    
  end
  
#  def retract ...
#  def update ...

  def handle_call({:assert, fact_template_name, fact_template}, _from, %{facts_supervisor: facts_supervisor, facts: facts} = state) do
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    # need to adjuts to pass in dynamic supervisor so fact servers can be added

    updated_facts = facts
    |> Map.put("#{fact_template_name}->#{DateTime.utc_now(:microsecond)}", fact_template)

    
    
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    #!!!!!!!!!111!!!!!!!!!!!!!!!

    


    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
    updated_facts |> IO.inspect(limit: :infinity)
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    
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
  
  def init(facts_supervisor) do
    {
      :ok,
       %{
         facts_supervisor: facts_supervisor,
         facts: %{}
       }
    }
  end
end
