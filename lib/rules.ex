defmodule Talisman.Rules do
  def assert(server, rule_name, rule) do
    GenServer.call({:add_rule, rule_name, rule})
    
  end

  def handle_call({:add_rule, rule_name, rule}, _from, %{rules: rules} = state) do
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    #!!!!!!!!!111!!!!!!!!!!!!!!!
    # need to adjust later when not using the test harness
    # instead changed to using a dynamic supervisor



    
    {
      :reply,
      :ok,
      state
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
