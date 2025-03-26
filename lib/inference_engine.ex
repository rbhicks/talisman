defmodule Talisman.InferenceEngine do
  use GenServer
  alias Talisman.Utilities



#  def load ...
#  def reset ...
#  def run ...

#  defp add_activated_rule ...
#  defp resolve_execution_order ...


  def start(facts_and_rules) do
    GenServer.start_link(__MODULE__, facts_and_rules)
  end
  
  def init([facts: facts, rules: rules]) do

    "kxxkxkxkxkxkxkxkxkxkxkxkxkxkxkxxkxkxkxkxkkxkxkxkkx" |> IO.puts
    "kxxkxkxkxkxkxkxkxkxkxkxkxkxkxkxxkxkxkxkxkkxkxkxkkx" |> IO.puts
    "kxxkxkxkxkxkxkxkxkxkxkxkxkxkxkxxkxkxkxkxkkxkxkxkkx" |> IO.puts
    facts |> IO.inspect(limit: :infinity)
    rules |> IO.inspect(limit: :infinity)
    "32232323232323232323232324234234234234234234234234" |> IO.puts
    "32232323232323232323232324234234234234234234234234" |> IO.puts
    "32232323232323232323232324234234234234234234234234" |> IO.puts
    
    {
      :ok,
       %{
         facts: facts,
         rules: rules
       }
    }
  end
end
