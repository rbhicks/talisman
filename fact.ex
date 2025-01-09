defmodule Athena.Fact do
  #takes pid, calls handler for 'get_field_values'
  #should be created automatically with __using__
#  @callback get_field_values ...

  defmacro __using__(_opts) do
    quote do
      def get_field_values(pid) do
        GenServer.call(pid, :get_field_values)
      end

      def handle_call(:get_field_values, _from, {fields_values: fields_values}) do
        {:reply, {:ok, fields_values}}
      end
    end
  end
end

