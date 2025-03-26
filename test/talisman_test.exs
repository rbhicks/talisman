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
 alias Talisman.Facts
 alias Talisman.Rules
 alias Talisman.InferenceEngine

 describe "fact" do
   context "smoke test" do

     @tag :skip
     it "china lake" do

       "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
       "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
       "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts
     
       [MissileFactTemplate, WarheadFactTemplate]
       |> Enum.sort()
       |> Enum.reduce("", fn template_name_atom, acc -> acc <> Atom.to_string(template_name_atom) end )
       |> then(fn template_names -> :crypto.hash(:sha256, template_names) end)
       |> Base.encode16()
       |> IO.inspect(limit: :infinity)

       "****************************************" |> IO.puts
       "****************************************" |> IO.puts
       "****************************************" |> IO.puts
     end
     @tag :skip
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
       InferenceEngine.create_fact_rule_lhs_cartesian_product(zorg)
       |> IO.inspect(limit: :infinity)
       "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts
       "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts
       "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts
     end

#     @tag :skip
     it "actually works" do

       facts_supervisor_child_spec =
         %{
           id: :facts_supervisor,
           start: {
             DynamicSupervisor,
             :start_link,
             [[name: :facts_supervisor]]
           }
         }

       rules_supervisor_child_spec =
         %{
           id: :rules_supervisor,
           start: {
             DynamicSupervisor,
             :start_link,
             [[name: :rules_supervisor]]
           }
         }
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       facts_supervisor = start_supervised!(facts_supervisor_child_spec) |> IO.inspect(limit: :infinity)
       rules_supervisor = start_supervised!(rules_supervisor_child_spec) |> IO.inspect(limit: :infinity)

       facts_child_spec =
         %{
           id: :facts,
           start: {
             Facts,
             :start,
             [[facts_supervisor: facts_supervisor]]
           }
         }

       rules_child_spec =
         %{
           id: :rules,
           start: {
             Rules,
             :start,
             [[rules_supervisor: rules_supervisor]]
           }
         }

       facts = start_supervised!(facts_child_spec) |> IO.inspect(limit: :infinity)
       rules = start_supervised!(rules_child_spec) |> IO.inspect(limit: :infinity)

       Facts.assert(facts, %MissileFactTemplate{
             name: :minuteman_ii,
             type: :icbm,
             propulsion: :solid_propellant,
             guidance: :ballistic_trajectory,
             warhead: :mirv
           })

       Facts.assert(facts, %BombFactTemplate{
             name: :b61,
             type: :gravity_bomb,
             guidance: :glide,
             warhead: :thermonuclear
           })

       Rules.add_rule(rules, :found_icbm, %{
           lhs_fact_templates: [MissileFactTemplate],
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
         })
       
       Rules.add_rule(rules, :assess_total_missile_yield, %{
           lhs_fact_templates: [MissileFactTemplate, WarheadFactTemplate],
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
         })

       "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts
       "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts
       "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts
       Facts.get_asserted_facts(facts) |> IO.inspect(limit: :infinity)
       "====================================================" |> IO.puts
       Rules.get_rules(rules) |> IO.inspect(limit: :infinity)
       "====================================================" |> IO.puts
       for {_, {_, rule_pid}} <- Rules.get_rules(rules) do
         Rule.get_lhs_fact_templates_hash(rule_pid)
         |> IO.inspect(limit: :infinity)
       end
       "))))))))))))))))))))))))))))))))))))))))))))))))))))" |> IO.puts
       "))))))))))))))))))))))))))))))))))))))))))))))))))))" |> IO.puts
       "))))))))))))))))))))))))))))))))))))))))))))))))))))" |> IO.puts

       
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
     end
   end
 end
end
