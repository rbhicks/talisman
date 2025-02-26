defmodule TalismanTest do
 use ExSpec, async: true

 alias Talisman.Test.Support.Fixtures.MissileFactTemplate
 alias Talisman.Test.Support.Fixtures.BombFactTemplate
 alias Talisman.Test.Support.Fixtures.GuidanceFactTemplate
 alias Talisman.Test.Support.Fixtures.WarheadFactTemplate
 alias Talisman.Test.Support.Fixtures.PropulsionFactTemplate
 alias Talisman.Fact
 alias Talisman.Rule
 alias Talisman.Mapper

 def create_fact_rule_lhs_cartesian_product([]), do: [[]]
  
 def create_fact_rule_lhs_cartesian_product(facts) do
   facts
   |> Enum.reduce([[]], fn current_fact_list, acc ->
     for x <- acc, y <- current_fact_list do
       [y | x]
     end
   end)
   |> Enum.map(&Enum.reverse/1)
 end

 describe "fact" do
   context "smoke test" do
#     @tag :skip
     it "white sands" do

       ack = [:ack_0, :ack_1, :ack_2, :ack_3, :ack_4]
       oop = [:oop_0, :oop_1]
       jbe = [:jbe_0, :jbe_1, :jbe_2]

       zorg = [ack, oop, jbe]

       # ack_0, oop_0, jbe_0
       # ack_0, oop_0, jbe_1
       # ack_0, oop_0, jbe_2
       # ack_0, oop_1, jbe_0
       # ack_0, oop_1, jbe_1
       # ack_0, oop_1, jbe_2

       # ack_1, oop_0, jbe_0
       # ack_1, oop_0, jbe_1
       # ack_1, oop_0, jbe_2
       # ack_1, oop_1, jbe_0
       # ack_1, oop_1, jbe_1
       # ack_1, oop_1, jbe_2

       # ack_2, oop_0, jbe_0
       # ack_2, oop_0, jbe_1
       # ack_2, oop_0, jbe_2
       # ack_2, oop_1, jbe_0
       # ack_2, oop_1, jbe_1
       # ack_2, oop_1, jbe_2

       # ack_3, oop_0, jbe_0
       # ack_3, oop_0, jbe_1
       # ack_3, oop_0, jbe_2
       # ack_3, oop_1, jbe_0
       # ack_3, oop_1, jbe_1
       # ack_3, oop_1, jbe_2

       # ack_4, oop_0, jbe_0
       # ack_4, oop_0, jbe_1
       # ack_4, oop_0, jbe_2
       # ack_4, oop_1, jbe_0
       # ack_4, oop_1, jbe_1
       # ack_4, oop_1, jbe_2

       # ===============================================

       # [
       #   [:ack_0, :ack_1, :ack_2, :ack_3, :ack_4],
       #   [:oop_0, :oop_1],
       #   [:jbe_0, :jbe_1, :jbe_2]
       # ]
       "fzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzt!" |> IO.puts
       "fzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzt!" |> IO.puts
       "fzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzt!" |> IO.puts
       # # for i <- ack, j <- oop, k <- jbe, reduce: [] do
       # #   acc -> [{i, j, k}|acc]
       # # end
       # # |> IO.inspect(limit: :infinity)
       # # zorg
       # # |> IO.inspect(limit: :infinity)
       create_fact_rule_lhs_cartesian_product(zorg)
       |> IO.inspect(limit: :infinity)
       "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts
       "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts
       "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts
     end

     @tag :skip
     it "actually works" do
       missile_fact_identity = "MissileFactTemplate->#{DateTime.utc_now(:microsecond)}"
       bomb_fact_identity = "BombFactTemplate->#{DateTime.utc_now(:microsecond)}"

       facts = %{
         missile_fact_identity => %{
           template: %MissileFactTemplate{
             name: :minuteman_ii,
             type: :icbm,
             propulsion: :solid_propellant,
             guidance: :ballistic_trajectory,
             warhead: :mirv
           }
         },
         bomb_fact_identity => %{
           template: %BombFactTemplate{
             name: :b61,
             type: :gravity_bomb,
             guidance: :glide,
             warhead: :thermonuclear
           }
         }
       }

       # @#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@$
       # add to mapper
       # fact templates can be added from the
       # rules, instead of a separate enumeration
       # because should a fact template not be
       # referenced by a rule, it's pointless
       # (should be pruned anyway)
       # @#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@$
       rules = %{
         found_icbm: %{
           get_lhs_fact_templates_function: fn -> [MissileFactTemplate] end,
           evaluate_lhs_function: fn fact_instances ->
             "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
             "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
             "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
             fact_instances |> IO.inspect(limit: :infinity)
             "+++++++++++++++++++++++++++++++++++" |> IO.puts
             "+++++++++++++++++++++++++++++++++++" |> IO.puts
             "+++++++++++++++++++++++++++++++++++" |> IO.puts
             {:ok}
           end,
           execute_rule_function: fn -> 
             "()()()()()()()()()()()()()()()()()()" |> IO.puts
             "fox-1" |> IO.puts
             "()()()()()()()()()()()()()()()()()()" |> IO.puts
           end
         },
         assess_total_missile_yield: %{
           get_lhs_fact_templates_function: fn -> [MissileFactTemplate, WarheadFactTemplate] end,
           evaluate_lhs_function: fn fact_instances ->
             "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
             "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
             "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
             fact_instances |> IO.inspect(limit: :infinity)
             "+++++++++++++++++++++++++++++++++++" |> IO.puts
             "+++++++++++++++++++++++++++++++++++" |> IO.puts
             "+++++++++++++++++++++++++++++++++++" |> IO.puts
             {:ok}
           end,
           execute_rule_function: fn -> 
             "()()()()()()()()()()()()()()()()()()" |> IO.puts
             "fox-1" |> IO.puts
             "()()()()()()()()()()()()()()()()()()" |> IO.puts
           end
         }
       }
       
       missile_fact_child_spec =
         %{
           id: missile_fact_identity,
           start: {
             Fact,
             :start,
             [
               Map.get(facts, missile_fact_identity).template,
               missile_fact_identity
             ]
           }
         }

       bomb_fact_child_spec =
         %{
           id: bomb_fact_identity,
           start: {
             Fact,
             :start,
             [
               Map.get(facts, bomb_fact_identity).template,
               bomb_fact_identity
             ]
           }
         }
       
       found_icbm_rule_child_spec =
         %{
           id: :found_icbm,
           start: {
             Rule,
             :start,
             [
               :found_icbm,
               rules.found_icbm.get_lhs_fact_templates_function,
               rules.found_icbm.evaluate_lhs_function,
               rules.found_icbm.execute_rule_function,
             ]
           }
         }

       assess_total_missile_yield_rule_child_spec =
         %{
           id: :assess_total_missile_yield,
           start: {
             Rule,
             :start,
             [
               :assess_total_missile_yield,
               rules.assess_total_missile_yield.get_lhs_fact_templates_function,
               rules.assess_total_missile_yield.evaluate_lhs_function,
               rules.assess_total_missile_yield.execute_rule_function,
             ]
           }
         }

       mapper_child_spec =
         %{
           id: :mapper,
           start: {
             Mapper,
             :start,
             [
             ]
           }
         }
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       start_supervised!(missile_fact_child_spec) |> IO.inspect(limit: :infinity)
       start_supervised!(bomb_fact_child_spec) |> IO.inspect(limit: :infinity)
       start_supervised!(found_icbm_rule_child_spec) |> IO.inspect(limit: :infinity)
       start_supervised!(assess_total_missile_yield_rule_child_spec) |> IO.inspect(limit: :infinity)
       mapper = start_supervised!(mapper_child_spec) |> IO.inspect(limit: :infinity)

       for {rule_name, rule} <- rules do
         Mapper.add_rule_fact_templates(mapper, rule_name, rule.get_lhs_fact_templates_function.())
       end

       Mapper.create_fact_template_to_rule_lhs_mapping(mapper)
       
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
     end
   end
 end
end
