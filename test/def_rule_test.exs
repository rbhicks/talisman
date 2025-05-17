defmodule DefRuleTest do
  use ExSpec, async: true

  require DefRule

  describe "************** WIP >>>>>>>>>>>>>>>>>>" do
    # @tag :skip

    it "-------- something --------" do
      DefRule.def_rule fn jbe, ack, oop, zorg ->
        fn
          ^jbe, 17 = ack when jbe > ack -> true
          _, _ -> false
        end
        fn -> {ack, oop, zorg} end
      end
    end
  end
end
