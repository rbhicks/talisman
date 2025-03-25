defmodule Talisman.Facts do
   alias Talisman.Fact
   
  def assert(server, fact_template) do
    GenServer.call(server, {:assert, fact_template})
  end
  
#  def retract ...
#  def update ...

  def handle_call({:assert, %fact_template_name{} = fact_template}, _from, %{facts_supervisor: facts_supervisor, facts: facts} = state) do

    asserted_fact_identity = "#{fact_template_name}->#{DateTime.utc_now(:microsecond)}"

    # updated_facts = %{
    #   id: asserted_fact_identity,
    #   start: {
    #     Fact,
    #     :start,
    #     [
    #       fact_template,
    #       asserted_fact_identity
    #     ]
    #   }
    # }
    # |> then(fn asserted_fact_child_spec -> DynamicSupervisor.start_child(facts_supervisor, asserted_fact_child_spec) end)
    # |> then(fn asserted_fact -> Map.put(facts, asserted_fact_identity, asserted_fact) end)

    ack = %{
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

    # "000000000000000000000000000000000000000000000000000000000000000" |> IO.puts
    # "000000000000000000000000000000000000000000000000000000000000000" |> IO.puts
    # "000000000000000000000000000000000000000000000000000000000000000" |> IO.puts
    # facts_supervisor |> IO.inspect(limit: :infinity)
    # "---------------------------------------------------------------" |> IO.puts
    # ack |> IO.inspect(limit: :infinity)
    # "---------------------------------------------------------------" |> IO.puts
    # "888888888888888888888888888888888888888888888888888888888888888" |> IO.puts
    # "888888888888888888888888888888888888888888888888888888888888888" |> IO.puts
    # "888888888888888888888888888888888888888888888888888888888888888" |> IO.puts

    updated_facts = ack
    |> then(fn asserted_fact_child_spec -> DynamicSupervisor.start_child(facts_supervisor, asserted_fact_child_spec) end)
    |> then(fn asserted_fact -> Map.put(facts, asserted_fact_identity, asserted_fact) end)



    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
    fact_template_name |> IO.puts
    "-------------------------------------------------"
    fact_template |> IO.inspect(limit: :infinity)
    "-------------------------------------------------"
    updated_facts |> IO.inspect(limit: :infinity)
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts

    # {
    #   :reply,
    #   :ok,
    #   state
    #   |> Map.put(:facts, updated_facts)
    # }
    {
      :reply,
      :ok,
      state
    }
  end

  def start([facts_supervisor]) do
    GenServer.start_link(__MODULE__, facts_supervisor)
  end
  
  def init({_, facts_supervisor_pid}) do
#  def init(facts_supervisor) do

    # "#$%^#$%^#$%^#$%^#$%^#$%^#$%^#$%^#$%^#$%^" |> IO.puts
    # "#$%^#$%^#$%^#$%^#$%^#$%^#$%^#$%^#$%^#$%^" |> IO.puts
    # "#$%^#$%^#$%^#$%^#$%^#$%^#$%^#$%^#$%^#$%^" |> IO.puts
    # facts_supervisor |> IO.inspect(limit: :infinity)
    # "JBXKJBXKJBXKJBXKJBXKJBXKJBXKJBXKJBXKJBBX" |> IO.puts
    # "JBXKJBXKJBXKJBXKJBXKJBXKJBXKJBXKJBXKJBBX" |> IO.puts
    # "JBXKJBXKJBXKJBXKJBXKJBXKJBXKJBXKJBXKJBBX" |> IO.puts
    
    {
      :ok,
       %{
         facts_supervisor: facts_supervisor_pid,
         facts: %{}
       }
    }
  end
end
