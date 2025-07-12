defmodule Talisman.Fact do
  use GenServer

  def get_fact_instance(server) do
    {:ok, field_values} = GenServer.call(server, :get_fact_instance)
    field_values
  end

  def get_field_values(server) do
    {:ok, field_values} = GenServer.call(server, :get_field_values)
    field_values
  end

  def set_field_values(server, field_values) do
    GenServer.call(server, {:set_field_values, field_values})
  end

  def handle_call(:get_fact_instance, _from, {fact_instance, _field_values, _fact_id} = state) do
    {:reply, {:ok, fact_instance}, state}
  end

  def handle_call(:get_field_values, _from, {_fact_instance, field_values, _fact_id} = state) do
    {:reply, {:ok, field_values}, state}
  end

  def handle_call({:set_field_values, field_values}, _from, state) do
    {current_fact_instance, current_field_values, fact_id} = state

    new_fact_instance =
      field_values
      |> Enum.reduce(current_fact_instance, fn {key, value}, acc ->
        Map.put(acc, key, value)
      end)

    new_field_values = Map.merge(current_field_values, field_values)

    {:reply, :ok, {new_fact_instance, new_field_values, fact_id}}
  end

  def start(fact_instance, fact_id) do
    GenServer.start_link(__MODULE__, {fact_instance, fact_id}, name: {:global, fact_id})
  end

  def init({fact_instance, fact_id}) do
    {
      :ok,
      {
        fact_instance,
        %{}
        |> Enum.into(Map.from_struct(fact_instance)),
        fact_id
      }
    }
  end
end
