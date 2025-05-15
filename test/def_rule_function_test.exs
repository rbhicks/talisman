defmodule DefRuleFunctionTest do
  use ExSpec, async: true

  require DefRuleFunction

  describe "************** WIP >>>>>>>>>>>>>>>>>>" do
    # @tag :skip

    it "-------- something --------" do
      # DefRuleFunction.def_rule_function fn jbe -> {jbe} end,
      # fn ack, oop, oop = zorg -> {ack, oop, zorg} end
      DefRuleFunction.def_rule_function fn x -> fn -> x * 2 end  end
    end
  end
end
