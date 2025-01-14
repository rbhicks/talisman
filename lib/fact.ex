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
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(params) do
    "mqvjkmbqvjkmb;qvjkmbqjvkmbqvjkmb;qvjkmb;vqjkmbq;jk" |> IO.puts
    "mqvjkmbqvjkmb;qvjkmbqjvkmbqvjkmb;qvjkmb;vqjkmbq;jk" |> IO.puts
    "mqvjkmbqvjkmb;qvjkmbqjvkmbqvjkmb;qvjkmb;vqjkmbq;jk" |> IO.puts
    params |> IO.inspect(limit: :infinity)
    "(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts
    "(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts
    "(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*&(*" |> IO.puts

    {:ok, %{}}
  end
end
