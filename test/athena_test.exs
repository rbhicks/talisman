defmodule AthenaTest do
 use ExSpec, async: true

 alias Athena.Test.Support.Fixtures.MissileFactTemplate

 describe "fact" do
   context "smoke test" do
     it "actually works" do
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       "uoansteuhosaetuhosaetnuhoaseuthoasutnohausoeuthau" |> IO.puts
       start_supervised!(
         {
           Athena.Fact,
           {
             MissileFactTemplate,
             %MissileFactTemplate{
               type: :icbm,
               propulsion: :solid_propellant,
               guidance: :ballistic_trajectory,
               warhead: :mirv
             }
           }
         }
       ) |> IO.inspect(limit: :infinity)
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
       "0394850349583045983405985039485034598304593840593" |> IO.puts
     end
   end
 end
end
