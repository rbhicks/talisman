defmodule Talisman do
  @moduledoc """
  Documentation for `Talisman`.
  """

  def start(_type, _args) do
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def cartesian_product(lists) do
    lists
    |> Enum.reduce([[]], fn list, acc ->
      for x <- acc, y <- list, do: x ++ [y]
    end)
  end  
end
