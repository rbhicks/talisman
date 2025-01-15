defmodule AthenaTest do
 use ExSpec, async: true

 alias Athena.Test.Support.Fixtures.MissileFactTemplate
 alias Athena.Test.Support.Fixtures.BombFactTemplate

 describe "fact" do
   context "smoke test" do
     it "actually works" do
       missile_fact_identity = "MissileFactTemplate->#{DateTime.utc_now(:microsecond)}"
       bomb_fact_identity = "BombFactTemplate->#{DateTime.utc_now(:microsecond)}"
       missile_fact_child_spec =
         %{
           id: missile_fact_identity,
           start: {
             Athena.Fact,
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
             Athena.Fact,
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
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       start_supervised!(missile_fact_child_spec) |> IO.inspect(limit: :infinity)
       start_supervised!(bomb_fact_child_spec) |> IO.inspect(limit: :infinity)
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
     end
   end
 end
end
