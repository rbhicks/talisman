defmodule TalismanTest do
 use ExSpec, async: true

 alias Talisman.Test.Support.Fixtures.MissileFactTemplate
 alias Talisman.Test.Support.Fixtures.BombFactTemplate
 alias Talisman.Test.Support.Fixtures.WarheadFactTemplate
 alias Talisman.Rule
 alias Talisman.Mapper
 alias Talisman.Facts
 alias Talisman.Rules
 alias Talisman.InferenceEngine

 setup_all do
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
   
   facts_supervisor = start_supervised!(facts_supervisor_child_spec)
   rules_supervisor = start_supervised!(rules_supervisor_child_spec)

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

   facts = start_supervised!(facts_child_spec)
   rules = start_supervised!(rules_child_spec)
   mapper = start_supervised!(mapper_child_spec)

   inference_engine_child_spec =
     %{
       id: :inference_engine,
       start: {
         InferenceEngine,
         :start,
         [[facts: facts, rules: rules]]
       }
     }

   inference_engine = start_supervised!(inference_engine_child_spec)

   Facts.assert(facts, %MissileFactTemplate{
         name: :minuteman_ii,
         type: :icbm,
         propulsion: :solid_propellant,
         guidance: :ballistic_trajectory,
         warhead: :mirv
                })

   Facts.assert(facts, %MissileFactTemplate{
         name: :aim_9c_sidewinder,
         type: :air_to_air,
         propulsion: :solid_propellant,
         guidance: :semi_active_radar,
         warhead: :continuous_rod
                })

   Facts.assert(facts, %MissileFactTemplate{
         name: :aim_9c_sidewinder,
         type: :air_to_air,
         propulsion: :solid_propellant,
         guidance: :semi_active_radar,
         warhead: :continuous_rod
                })

   Facts.assert(facts, %BombFactTemplate{
         name: :b61,
         type: :gravity_bomb,
         guidance: :glide,
         warhead: :thermonuclear
                })

   Rules.add_rule(rules, :found_icbm, %{
         lhs_fact_template_names: [MissileFactTemplate],
         lhs_fact_multiplicity: %{MissileFactTemplate => 1},
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
         lhs_fact_template_names: [MissileFactTemplate, WarheadFactTemplate],
         lhs_fact_multiplicity: %{MissileFactTemplate => 1, WarheadFactTemplate => 1},
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

   Rules.add_rule(rules, :found_f22_aim_9c_loadout, %{
         lhs_fact_template_names: [MissileFactTemplate],
         lhs_fact_multiplicity: %{MissileFactTemplate => 2},
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

   %{
     facts_supervisor: facts_supervisor,
     rules_supervisor: rules_supervisor,
     facts: facts,
     rules: rules,
     inference_engine: inference_engine,
     mapper: mapper
   }
 end
    
 describe "basic fact and rule functionality" do

#   @tag :skip
   it "facts_supervisor is created successfully", (%{facts_supervisor: facts_supervisor}) do
     assert is_pid(facts_supervisor)
   end
   
#   @tag :skip
   it "facts is created successfully", (%{facts: facts}) do
     assert is_pid(facts)
   end

#   @tag :skip
   it "facts are asserted (added not test 'asserted' correctly", (%{facts: facts}) do
     assert 4 == Facts.get_asserted_facts(facts) |> Enum.count     
   end

   #   @tag :skip
   it "rules_supervisor is created successfully", (%{rules_supervisor: rules_supervisor}) do
     assert is_pid(rules_supervisor)
   end
   
#   @tag :skip
   it "rules is created successfully", (%{rules: rules}) do
     assert is_pid(rules)
   end

#   @tag :skip
   it "rules are added correctly", (%{rules: rules}) do
     assert 3 == Rules.get_rules(rules) |> Enum.count     
   end

#   @tag :skip
   it "inference_engine is created successfully", (%{inference_engine: inference_engine}) do
     assert is_pid(inference_engine)
   end

#   @tag :skip
   it "lhs fact template name hashes powerset is generated correctly", (%{inference_engine: inference_engine}) do
     # git rid of magic numbers
     assert ["4A64ACD9845B274E6DCF7F508B1E3976916DCD0B1F20681ABAD321797BF2C835",
             "7861415FF6169E951B6B72F3586814B24D804993D3ED527ED848D31D784335F5",
             "1B9F8BFDC88F66DD933E46C59410504410E60D3B8F1BF92B6E06F24A97678F70"] =
       InferenceEngine.generate_lhs_fact_template_name_hashes_powerset(inference_engine)
   end

#   @tag :skip
   it "asserted facts template name hashes powerset is generated correctly", (%{inference_engine: inference_engine}) do
     # git rid of magic numbers
     assert ["E6B0C80031D576218F3B16E7B5B2488D59478F74CA89A7E14333EB4322A1DA05",
             "4A64ACD9845B274E6DCF7F508B1E3976916DCD0B1F20681ABAD321797BF2C835",
             "7BFA303F8D468672B4383A26CBF4452DAAF9162651EF24475922A24050A95D64" ] =
       InferenceEngine.generate_asserted_facts_template_name_hashes_powerset(inference_engine)
   end

#   @tag :skip
   it "mapper is created successfully", (%{mapper: mapper}) do
     assert is_pid(mapper)
   end

#   @tag :skip
   it "fact template to rule lhs mapping is created successfully", (%{rules: rules, mapper: mapper}) do
     for {_, {rule_name, rule_pid}} <- Rules.get_rules(rules) do
       Mapper.add_rule_fact_templates(mapper, rule_name, Rule.get_lhs_fact_template_names(rule_pid))
     end
     
     Mapper.create_fact_template_to_rule_lhs_mapping(mapper)

     # this probably isn't guaranteed to be deterministic.
     # change it
     assert %{
       Talisman.Test.Support.Fixtures.MissileFactTemplate => [:found_icbm,
                                                              :assess_total_missile_yield, :found_f22_aim_9c_loadout],
       Talisman.Test.Support.Fixtures.WarheadFactTemplate => [:assess_total_missile_yield]
     } =
     Mapper.get_fact_template_to_rule_lhs_mapping(mapper)
   end

#   @tag :skip
   it "the lhs fact template names hashes are created successfully", (%{rules: rules}) do
     lhs_fact_template_names_hashes = for {_, {_, rule_pid}} <- Rules.get_rules(rules) do
       Rule.get_lhs_fact_template_names_hash(rule_pid)
     end
     # git rid of magic numbers
     # this probably isn't guaranteed to be deterministic.
     # change it
     assert ^lhs_fact_template_names_hashes =
       ["4A64ACD9845B274E6DCF7F508B1E3976916DCD0B1F20681ABAD321797BF2C835",
        "1B9F8BFDC88F66DD933E46C59410504410E60D3B8F1BF92B6E06F24A97678F70",
        "4A64ACD9845B274E6DCF7F508B1E3976916DCD0B1F20681ABAD321797BF2C835"]
   end

#   @tag :skip
   it "the lhs fact multiplicities are created successfully", (%{rules: rules}) do
     lhs_fact_multiplicities = for {_, {_, rule_pid}} <- Rules.get_rules(rules) do
       Rule.get_lhs_fact_multiplicity(rule_pid)
     end     
     # git rid of magic numbers
     # this probably isn't guaranteed to be deterministic.
     # change it
     assert ^lhs_fact_multiplicities =
     [
       %{Talisman.Test.Support.Fixtures.MissileFactTemplate => 1},
       %{
         Talisman.Test.Support.Fixtures.MissileFactTemplate => 1,
         Talisman.Test.Support.Fixtures.WarheadFactTemplate => 1
       },
       %{Talisman.Test.Support.Fixtures.MissileFactTemplate => 2}
     ]
   end
 end
end
