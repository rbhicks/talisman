defmodule Talisman.Rules do
  def add_rule(server, rule_name, rule) do
    GenServer.call({:add_rule, rule_name, rule})
    
  end

  def handle_call({:add_rule, rule_name, rule}, _from, %{rules_supervisor: rules_supervisor, rules: rules} = state) do

    # updated_rules = ${
    #   id: rule_name,
    #   start: {
    #     Rule,
    #     :start,
    #     [
    #       rule_name,
          
    #     ]
    #   }
    # }

    
    {
      :reply,
      :ok,
      state
    }
  end

  def start() do
    GenServer.start_link(__MODULE__, nil)
  end
  
  def init({_, rules_supervisor}) do
    {
      :ok,
       %{
         rules_supervisor: rules_supervisor,
         rules: %{}
       }
    }
  end
end
