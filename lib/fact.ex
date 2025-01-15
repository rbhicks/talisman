defmodule Athena.Fact do
  use GenServer
  
  def get_field_values(pid) do
    GenServer.call(pid, :get_field_values)
  end

  def set_field_values(pid, field_values) do
    GenServer.cast(pid, :set_field_values)
  end

  def handle_call(:get_field_values, _from, %{fields_values: fields_values}) do
    {:reply, {:ok, fields_values}}
  end

  def handle_cast({:set_field_values, field_values}, _from, state) do
    {:no_reply, Map.put(state, :field_values, field_values)}
  end

  def start(fact_instance, fact_id) do
    GenServer.start_link(__MODULE__, {fact_instance, fact_id}, name: {:global, fact_id})
  end

  def init({fact_instance, fact_id}) do
    {
      :ok,
      {
        fact_instance.__struct__,
        %{}
        |> Enum.into(Map.from_struct(fact_instance)),
        fact_id
      }
    }
  end
end
