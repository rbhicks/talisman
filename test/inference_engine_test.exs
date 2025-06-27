defmodule InferenceEngineTest do
  use ExSpec, async: true

  require DefRule

  alias Talisman.Test.Support.Fixtures.MissileFactTemplate
  alias Talisman.Test.Support.Fixtures.BombFactTemplate
  alias Talisman.Test.Support.Fixtures.WarheadFactTemplate
  alias Talisman.Test.Support.Fixtures.PropulsionFactTemplate
  alias Talisman.Test.Support.Fixtures.RuleTestResultFactTemplate
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

    mapper_child_spec =
      %{
        id: :mapper,
        start: {
          Mapper,
          :start,
          []
        }
      }

    mapper = start_supervised!(mapper_child_spec)

    inference_engine_child_spec =
      %{
        id: :inference_engine,
        start: {
          InferenceEngine,
          :start,
          [[mapper: mapper]]
        }
      }

    inference_engine = start_supervised!(inference_engine_child_spec)

    facts_child_spec =
      %{
        id: :facts,
        start: {
          Facts,
          :start,
          [
            [
              facts_supervisor: facts_supervisor,
              inference_engine: inference_engine,
              mapper: mapper
            ]
          ]
        }
      }

    rules_child_spec =
      %{
        id: :rules,
        start: {
          Rules,
          :start,
          [[rules_supervisor: rules_supervisor, inference_engine: inference_engine]]
        }
      }

    facts = start_supervised!(facts_child_spec)
    rules = start_supervised!(rules_child_spec)

    InferenceEngine.set_facts(inference_engine, facts)
    InferenceEngine.set_rules(inference_engine, rules)

    Facts.assert(
      facts,
      %MissileFactTemplate{
        name: :minuteman_ii,
        type: :icbm,
        propulsion: :solid_propellant,
        guidance: :ballistic_trajectory,
        warhead: :mirv
      }
    )

    Facts.assert(
      facts,
      %MissileFactTemplate{
        name: :minuteman_ii,
        type: :icbm,
        propulsion: :solid_propellant,
        guidance: :ballistic_trajectory,
        warhead: :mirv
      }
    )

    Facts.assert(
      facts,
      %MissileFactTemplate{
        name: :aim_9c_sidewinder,
        type: :air_to_air,
        propulsion: :solid_propellant,
        guidance: :semi_active_radar,
        warhead: :continuous_rod
      }
    )

    # Facts.assert(
    #   facts,
    #   %MissileFactTemplate{
    #     name: :aim_9c_sidewinder,
    #     type: :air_to_air,
    #     propulsion: :solid_propellant,
    #     guidance: :semi_active_radar,
    #     warhead: :continuous_rod
    #   }
    # )

    Facts.assert(
      facts,
      %BombFactTemplate{
        name: :b61,
        type: :gravity_bomb,
        guidance: :glide,
        warhead: :thermonuclear
      }
    )

    Facts.assert(
      facts,
      %BombFactTemplate{
        name: :b61,
        type: :gravity_bomb,
        guidance: :glide,
        warhead: :thermonuclear
      }
    )

    Facts.assert(
      facts,
      %BombFactTemplate{
        name: :b61,
        type: :gravity_bomb,
        guidance: :glide,
        warhead: :thermonuclear
      }
    )

    # Facts.assert(
    #   facts,
    #   %PropulsionFactTemplate{
    #     name: :f107_wr_400,
    #     type: :turbofan,
    #     power: :"2.7_kN"
    #   }
    # )

    # Facts.assert(
    #   facts,
    #   %PropulsionFactTemplate{
    #     name: :"f107_wr_105/401",
    #     type: :turbofan,
    #     power: :"6.22_kN"
    #   }
    # )

    # Facts.assert(
    #   facts,
    #   %WarheadFactTemplate{
    #     name: :W80,
    #     type: :thermonuclear,
    #     yield: :"21-628_TJ"
    #   }
    # )

    DefRule.def_rule(rules, :found_icbm, fn %MissileFactTemplate{} = missile ->
      fn ->
        if missile.type == :icbm do
          true
        else
          false
        end
      end

      fn ->
        Facts.assert(
          facts,
          %RuleTestResultFactTemplate{
            result: :found_icbm
          }
        )
      end
    end)

    DefRule.def_rule(rules, :found_air_to_air, fn %MissileFactTemplate{} = missile ->
      fn ->
        if missile.type == :air_to_air do
          true
        else
          false
        end
      end

      fn ->
        Facts.assert(
          facts,
          %RuleTestResultFactTemplate{
            result: :found_air_to_air
          }
        )
      end
    end)

    DefRule.def_rule(rules, :found_gravity_bomb, fn %BombFactTemplate{} = bomb ->
      fn ->
        if bomb.type == :gravity_bomb do
          true
        else
          false
        end
      end

      fn ->
        Facts.assert(
          facts,
          %RuleTestResultFactTemplate{
            result: :found_gravity_bomb
          }
        )
      end
    end)

    # DefRule.def_rule(rules, :assess_total_missile_yield, fn %MissileFactTemplate{} = missile,
    #                                                         %WarheadFactTemplate{} = warhead ->
    #   fn ->
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # missile |> IO.inspect(limit: :infinity)
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     false
    #   end

    #   fn ->
    #     "()()()()()()()()()()()()()()()()()()" |> IO.puts()
    #     "fox-1" |> IO.puts()
    #     "()()()()()()()()()()()()()()()()()()" |> IO.puts()
    #   end
    # end)

    # DefRule.def_rule(rules, :found_f22_aim_9c_loadout, fn %MissileFactTemplate{} = sidewinder_0,
    #                                                       %MissileFactTemplate{} = sidewinder_1 ->
    #   fn ->
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # sidewinder_0 |> IO.inspect(limit: :infinity)
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     false
    #   end

    #   fn ->
    #     "()()()()()()()()()()()()()()()()()()" |> IO.puts()
    #     "fox-1" |> IO.puts()
    #     "()()()()()()()()()()()()()()()()()()" |> IO.puts()
    #   end
    # end)

    # DefRule.def_rule(rules, :found_jet_powered_missile, fn %MissileFactTemplate{} = missile,
    #                                                        %PropulsionFactTemplate{} = propulsion ->
    #   fn ->
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # propulsion |> IO.inspect(limit: :infinity)
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     true
    #   end

    #   fn ->
    #     "()()()()()()()()()()()()()()()()()()" |> IO.puts()
    #     "fox-1" |> IO.puts()
    #     "()()()()()()()()()()()()()()()()()()" |> IO.puts()
    #   end
    # end)

    # DefRule.def_rule(rules, :found_nuclear_cruise_missile, fn %WarheadFactTemplate{} = warhead,
    #                                                           %PropulsionFactTemplate{} =
    #                                                             propulsion,
    #                                                           %MissileFactTemplate{} = missile ->
    #   fn ->
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
    #     # warhead |> IO.inspect(limit: :infinity)
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
    #     true
    #   end

    #   fn ->
    #     "()()()()()()()()()()()()()()()()()()" |> IO.puts()
    #     "fox-1" |> IO.puts()
    #     "()()()()()()()()()()()()()()()()()()" |> IO.puts()
    #   end
    # end)

    for {_, {rule_name, rule_pid}} <- Rules.get_rules(rules) do
      Mapper.add_rule_fact_template_names(
        mapper,
        rule_name,
        Rule.get_lhs_fact_template_names(rule_pid)
      )
    end

    Mapper.create_fact_template_name_to_rule_lhs_mapping(mapper)

    %{
      facts_supervisor: facts_supervisor,
      rules_supervisor: rules_supervisor,
      facts: facts,
      rules: rules,
      inference_engine: inference_engine,
      mapper: mapper
    }
  end

  describe "rule activations" do
    #   @tag :skip
    it "simple rule test", %{inference_engine: inference_engine, facts: facts} do
      InferenceEngine.run(inference_engine)

      "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts()
      "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts()
      "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts()
      Facts.get_asserted_facts(facts) |> IO.inspect(limit: :infinity)
      "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" |> IO.puts()
      "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" |> IO.puts()
      "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" |> IO.puts()
    end
  end
end
