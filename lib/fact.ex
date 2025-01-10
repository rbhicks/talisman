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

  def start_link(opts) do
    "mqvjkmbqvjkmb;qvjkmbqjvkmbqvjkmb;qvjkmb;vqjkmbq;jk" |> IO.puts
    "mqvjkmbqvjkmb;qvjkmbqjvkmbqvjkmb;qvjkmb;vqjkmbq;jk" |> IO.puts
    "mqvjkmbqvjkmb;qvjkmbqjvkmbqvjkmb;qvjkmb;vqjkmbq;jk" |> IO.puts
#    __MODULE__.__struct__() |> Map.from_struct() |> Map.keys() |> IO.inspect(limit: :infinity)
    opts |> IO.inspect(limit: :infinity)
    "(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts
    "(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts
    "(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts
        
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_params) do
    {:ok, %{}}
  end
end
