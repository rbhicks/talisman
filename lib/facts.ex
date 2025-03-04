defmodule Talisman.FactProcessor do
  def assert(server, fact_template_name, fact_template) do
    GenServer.call({:assert, fact_template_name, fact_template})
    
  end
  
#  def retract ...
#  def update ...

  def handle_call({:assert, fact_template_name, fact_template}, _from, %{facts: facts} = state) do
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    # need to adjust later when not using the test harness
    # instead changed to using a dynamic supervisor

    updated_facts = facts
    |> Map.put("#{fact_template_name}->#{DateTime.utc_now(:microsecond)}", fact_template}


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

  def start() do
    GenServer.start_link(__MODULE__, nil)
  end
  
  def init(_) do
    {
      :ok,
       %{facts: %{}}
    }
  end
end
