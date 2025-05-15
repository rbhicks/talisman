defmodule DefRuleFunctionTest do
  use ExSpec, async: true

  require DefRuleFunction

  describe "************** WIP >>>>>>>>>>>>>>>>>>" do
    # @tag :skip

    it "-------- something --------" do
      DefRuleFunction.def_rule_function :evaluate_lhs_function, do: fn ack ->
        "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
        "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
        "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" |> IO.puts
        ack |> IO.inspect(limit: :infinity)
        "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" |> IO.puts
        "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" |> IO.puts
        "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" |> IO.puts
      end
    end
  end
end
