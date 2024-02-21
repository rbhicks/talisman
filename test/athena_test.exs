defmodule AthenaTest do
  use ExUnit.Case
  doctest Athena

  test "greets the world" do
    assert Athena.hello() == :world
  end
end
