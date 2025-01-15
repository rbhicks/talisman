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

#  def start_link({module, fact, fact_id} = opts) do
  def start(fact_instance, fact_id) do

    "**********************************************" |> IO.puts
    "**********************************************" |> IO.puts
    "**********************************************" |> IO.puts
    fact_instance |> IO.inspect(limit: :infinity)
    "==============================================" |> IO.puts
    fact_id |> IO.inspect(limit: :infinity)
    "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
    "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
    "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
#    {:ok, self()}
    GenServer.start_link(__MODULE__, {fact_instance, fact_id}, name: {:global, fact_id})
  end

  def init(params) do

    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
    params |> IO.inspect(limit: :infinity)
    "#################################################" |> IO.puts
    "#################################################" |> IO.puts
    "#################################################" |> IO.puts
    {
      :ok,
      {
        elem(params, 0),
        %{}
        |> Enum.into(Map.from_struct(elem(params, 1))),
        elem(params, 2)
      }
    }
  end
end
