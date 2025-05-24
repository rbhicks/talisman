defmodule DefRuleTest do
  use ExSpec, async: true

  require DefRule

  alias Talisman.Test.Support.Fixtures.MissileFactTemplate
  alias Talisman.Test.Support.Fixtures.PropulsionFactTemplate
  alias Talisman.Rules

  describe "************** WIP >>>>>>>>>>>>>>>>>>" do
    # @tag :skip

    it "-------- something --------" do
      DefRule.def_rule :found_jet_powered_missile, fn %MissileFactTemplate{} = missile, %PropulsionFactTemplate{} = propulsion ->
        fn
          ^missile, ^propulsion = propulsion when propulsion == :jet -> true
          _, _ -> false
        end
        fn -> {missile, propulsion} end
      end
    end
  end
end

# fn %MissileFactTemplate{} = missile, %PropulsionFactTemplate{} = propulsion ->

#         Rules.add_rule(rules, :found_icbm, %{
#               lhs_fact_template_names: [MissileFactTemplate],
#               lhs_fact_multiplicity: %{MissileFactTemplate => 1},
#               evaluate_lhs_function: fn
#                 ^missile, ^propulsion = propulsion when propulsion == :jet -> true
#                 _, _ -> false
#               end,
#               execute_rule_function: fn -> {missile, propulsion} end
#         })
# end
