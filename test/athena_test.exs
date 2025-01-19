defmodule AthenaTest do
 use ExSpec, async: true

 alias Athena.Test.Support.Fixtures.MissileFactTemplate
 alias Athena.Test.Support.Fixtures.BombFactTemplate
 alias Athena.Fact
 alias Athena.Rule

 describe "fact" do
   context "smoke test" do
     it "actually works" do
       missile_fact_identity = "MissileFactTemplate->#{DateTime.utc_now(:microsecond)}"
       bomb_fact_identity = "BombFactTemplate->#{DateTime.utc_now(:microsecond)}"
       missile_fact_child_spec =
         %{
           id: missile_fact_identity,
           start: {
             Fact,
             :start,
             [
               %MissileFactTemplate{
                 name: :minuteman_ii,
                 type: :icbm,
                 propulsion: :solid_propellant,
                 guidance: :ballistic_trajectory,
                 warhead: :mirv
               },
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
               %BombFactTemplate{
                 name: :b61,
                 type: :gravity_bomb,
                 guidance: :glide,
                 warhead: :thermonuclear
               },
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
               fn -> [MissileFactTemplate] end,
               fn fact_instances ->
                 "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
                 "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
                 "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts
                 fact_instances |> IO.inspect(limit: :infinity)
                 "+++++++++++++++++++++++++++++++++++" |> IO.puts
                 "+++++++++++++++++++++++++++++++++++" |> IO.puts
                 "+++++++++++++++++++++++++++++++++++" |> IO.puts
                 {:ok}
               end,
               fn -> 
                 "()()()()()()()()()()()()()()()()()()" |> IO.puts
                 "fox-1" |> IO.puts
                 "()()()()()()()()()()()()()()()()()()" |> IO.puts
               end
             ]
           }
         }

       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       start_supervised!(missile_fact_child_spec) |> IO.inspect(limit: :infinity)
       start_supervised!(bomb_fact_child_spec) |> IO.inspect(limit: :infinity)
       start_supervised!(found_icbm_rule_child_spec) |> IO.inspect(limit: :infinity)
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
     end
   end
 end
end
