defmodule AthenaTest do
 use ExSpec, async: true

 alias Athena.Test.Support.Fixtures.MissileFactTemplate
 alias Athena.Test.Support.Fixtures.BombFactTemplate
 alias Athena.Fact
 alias Athena.Rule
 alias Athena.Mapper

 describe "fact" do
   context "smoke test" do
     it "white sands" do
       "fzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzt!" |> IO.puts
       "fzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzt!" |> IO.puts
       "fzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzt!" |> IO.puts
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
       mapper = start_supervised!(mapper_child_spec) |> IO.inspect(limit: :infinity)

       for {rule_name, rule} <- rules do
         Mapper.add_rule_fact_templates(mapper, rule_name, rule.get_lhs_fact_templates_function.())
       end
      
       
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
     end
   end
 end
end
