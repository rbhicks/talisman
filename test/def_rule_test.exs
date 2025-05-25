defmodule DefRuleTest do
  use ExUnit.Case

  require DefRule

  alias Talisman.Test.Support.Fixtures.MissileFactTemplate
  alias Talisman.Test.Support.Fixtures.PropulsionFactTemplate

  test "def_rule preserves variable bindings" do
    rules = :zorg

    DefRule.def_rule(rules, :found_jet_powered_missile, fn %MissileFactTemplate{} = missile,
                                                           %PropulsionFactTemplate{} = propulsion ->
      fn
        ^missile, ^propulsion = propulsion when propulsion == :jet -> true
        _, _ -> false
      end

      fn -> {missile, propulsion} end
    end)

    # Add assertions to verify Rules.add_rule
  end
end
