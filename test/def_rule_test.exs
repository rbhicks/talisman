defmodule DefRuleTest do
  use ExSpec, async: true

  require DefRule

  alias Talisman.Test.Support.Fixtures.MissileFactTemplate
  alias Talisman.Test.Support.Fixtures.PropulsionFactTemplate


  describe "************** WIP >>>>>>>>>>>>>>>>>>" do
    # @tag :skip

    it "-------- something --------" do
      DefRule.def_rule fn MissileFactTemplate = missile, PropulsionFactTemplate = propulsion ->
        fn
          ^missile, ^propulsion = propulsion when propulsion == :jet -> true
          _, _ -> false
        end
        fn -> {missile, propulsion} end
      end
    end
  end
end
