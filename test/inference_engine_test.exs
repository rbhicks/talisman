defmodule InferenceEngineTest do
  use ExSpec, async: true

  require DefRule

  alias Talisman.Test.Support.Fixtures.MissileFactTemplate
  alias Talisman.Test.Support.Fixtures.BombFactTemplate
  alias Talisman.Test.Support.Fixtures.WarheadFactTemplate
  alias Talisman.Test.Support.Fixtures.PropulsionFactTemplate
  alias Talisman.Test.Support.Fixtures.RuleTestResultFactTemplate
  alias Talisman.Fact
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

    Facts.assert(
      facts,
      %BombFactTemplate{
        name: :moab,
        type: :gravity_bomb,
        guidance: :gps,
        warhead: :fae
      }
    )

    Facts.assert(
      facts,
      %BombFactTemplate{
        name: :blu_109,
        type: :gravity_bomb,
        guidance: :gps,
        warhead: :fae
      }
    )

    Facts.assert(
      facts,
      %PropulsionFactTemplate{
        name: :"f107_wr_105/401",
        type: :turbofan,
        power: :"6.22_kN"
      }
    )

    Facts.assert(
      facts,
      %WarheadFactTemplate{
        name: :W80,
        type: :thermonuclear,
        yield: :"21-628_TJ"
      }
    )

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
        if bomb.type == :gravity_bomb and bomb.name == :blu_109 do
          true
        else
          false
        end
      end

      fn ->
        Facts.retract(facts, bomb.id)

        Facts.assert(
          facts,
          %RuleTestResultFactTemplate{
            result: :found_gravity_bomb
          }
        )
      end
    end)

    DefRule.def_rule(rules, :found_f22_aim_9c_loadout, fn %MissileFactTemplate{} = missile_0,
                                                          %MissileFactTemplate{} = missile_1 ->
      fn ->
        if missile_0.name == :aim_9c_sidewinder and missile_1.name == :aim_9c_sidewinder do
          true
        else
          false
        end
      end

      fn ->
        Facts.assert(
          facts,
          %RuleTestResultFactTemplate{
            result: :found_f22_aim_9c_loadout
          }
        )
      end
    end)

    DefRule.def_rule(rules, :update_gravity_bomb, fn %BombFactTemplate{} = bomb ->
      fn ->
        if bomb.type == :gravity_bomb and bomb.name == :moab do
          true
        else
          false
        end
      end

      fn ->
        Facts.update(facts, bomb.id, %{name: :mop})

        Facts.assert(
          facts,
          %RuleTestResultFactTemplate{
            result: {:update_gravity_bomb, bomb.id}
          }
        )
      end
    end)

    # N.B.: these next two multi fact template LHS rules wouldn't actually work
    # in practice as the fact templates don't have a "connecting field"; i.e., not
    # the actual individual fact id, but an id-like field that connects the components
    # of an aggregate together. this is a fuction of the expert system itself not
    # talisman. these tests just make sure that multiplicity works. were there such
    # a "connecting field", it would have the same semantics and the same functionality
    # as these tests. so, while these rules are faulty at the expert system level the
    # the tests for talisman are valid.
    DefRule.def_rule(rules, :found_jet_powered_missile, fn %MissileFactTemplate{} = _missile,
                                                           %PropulsionFactTemplate{} = propulsion ->
      fn ->
        if propulsion.type == :turbofan do
          true
        else
          false
        end
      end

      fn ->
        Facts.assert(
          facts,
          %RuleTestResultFactTemplate{
            result: :found_jet_powered_missile
          }
        )
      end
    end)

    DefRule.def_rule(rules, :found_nuclear_cruise_missile, fn %WarheadFactTemplate{} = warhead,
                                                              %PropulsionFactTemplate{} =
                                                                propulsion,
                                                              %MissileFactTemplate{} = _missile ->
      fn ->
        if warhead.type == :thermonuclear and propulsion.type == :turbofan do
          true
        else
          false
        end
      end

      fn ->
        Facts.assert(
          facts,
          %RuleTestResultFactTemplate{
            result: :found_nuclear_cruise_missile
          }
        )
      end
    end)

    for {_, {rule_name, rule_pid}} <- Rules.get_rules(rules) do
      Mapper.add_rule_fact_template_names(
        mapper,
        rule_name,
        Rule.get_lhs_fact_template_names(rule_pid)
      )
    end

    Mapper.create_fact_template_name_to_rule_lhs_mapping(mapper)

    InferenceEngine.run(inference_engine)

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
    # @tag :skip
    it "a simple rule works", %{facts: facts} do
      result_frequencies = get_result_frequencies(facts)

      assert result_frequencies.found_icbm == 2
      assert result_frequencies.found_air_to_air == 2
      assert result_frequencies.found_gravity_bomb == 1
    end

    # @tag :skip
    it "multiple facts of same type rule works", %{facts: facts} do
      result_frequencies = get_result_frequencies(facts)
      assert result_frequencies.found_f22_aim_9c_loadout == 2
    end

    # @tag :skip
    it "rule that updates a fact works", %{facts: facts} do
      result_frequencies = get_result_frequencies(facts)
      asserted_facts = Facts.get_asserted_facts(facts)

      {{_, updated_gravity_bomb_id}, _} =
        result_frequencies
        |> Enum.filter(fn {key, _} ->
          is_tuple(key)
        end)
        |> Enum.filter(fn {{type, id}, _} ->
          type == :update_gravity_bomb
        end)
        |> hd()

      {_, updated_gravity_bomb_pid} =
        asserted_facts
        |> Map.get(updated_gravity_bomb_id)

      updated_gravity_bomb_field_values = Fact.get_field_values(updated_gravity_bomb_pid)

      assert updated_gravity_bomb_field_values.name == :mop
    end

    # @tag :skip
    it "two different fact template LHS works", %{facts: facts} do
      result_frequencies = get_result_frequencies(facts)

      assert result_frequencies.found_jet_powered_missile == 4
    end

    # @tag :skip
    it "three different fact template LHS works", %{facts: facts} do
      result_frequencies = get_result_frequencies(facts)

      assert result_frequencies.found_nuclear_cruise_missile == 4
    end
  end

  describe "inference engine functions" do
    @tag :skip
    # this test really only needs to be run once. it's almost unecessary...
    # it also breaks all the other tests. i've yet to find a way to use
    # async and force a test to run last, so i'll leave it here, but skip
    # it. if ever needed, it can be run manually.
    it "clear works", %{inference_engine: inference_engine, facts: facts} do
      InferenceEngine.clear(inference_engine)

      assert Facts.get_asserted_facts(facts) == %{}
    end

    it "lhs/asserted fact rule filtering works", %{facts: facts, rules: rules, mapper: mapper} do
      sorted_expected_rules = [
        :found_air_to_air,
        :found_f22_aim_9c_loadout,
        :found_gravity_bomb,
        :found_icbm,
        :found_jet_powered_missile,
        :found_nuclear_cruise_missile,
        :update_gravity_bomb]
      sorted_rules_filtered_by_lhs_and_asserted_fact_template_names =
        InferenceEngine.filter_rules_by_rule_lhs_and_asserted_fact_template_names(facts, rules, mapper)
        |> Enum.sort()
      
      assert sorted_expected_rules == sorted_rules_filtered_by_lhs_and_asserted_fact_template_names
    end

    it "rule name/rule pid/fact template name/asserted fact pid mapping works", %{facts: facts, rules: rules, mapper: mapper} do
      sorted_expected_mappings =
        [
          {
            :found_air_to_air,
            [
              [
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate
              ]
            ]
          },
          {
            :found_f22_aim_9c_loadout,
            [
              [
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate
              ],
              [
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate
              ]
            ]
          },
          {
            :found_gravity_bomb,
            [
              [
                Talisman.Test.Support.Fixtures.BombFactTemplate,
                Talisman.Test.Support.Fixtures.BombFactTemplate,
                Talisman.Test.Support.Fixtures.BombFactTemplate,
                Talisman.Test.Support.Fixtures.BombFactTemplate
              ]
            ]
          },
          {
            :found_icbm,
            [
              [
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate
              ]
            ]
          },
          {
            :found_jet_powered_missile,
            [
              [
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate
              ],
              [
                Talisman.Test.Support.Fixtures.PropulsionFactTemplate
              ]
            ]
          },
          {
            :found_nuclear_cruise_missile,
            [
              [
                Talisman.Test.Support.Fixtures.WarheadFactTemplate
              ],
              [
                Talisman.Test.Support.Fixtures.PropulsionFactTemplate
              ],
              [
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate,
                Talisman.Test.Support.Fixtures.MissileFactTemplate
              ]
            ]
          },
          {
            :update_gravity_bomb,
            [
              [
                Talisman.Test.Support.Fixtures.BombFactTemplate,
                Talisman.Test.Support.Fixtures.BombFactTemplate,
                Talisman.Test.Support.Fixtures.BombFactTemplate,
                Talisman.Test.Support.Fixtures.BombFactTemplate
              ]
            ]
          }
        ]
      rules_filtered_by_lhs_and_asserted_fact_template_names =
        InferenceEngine.filter_rules_by_rule_lhs_and_asserted_fact_template_names(facts, rules, mapper)

      processed_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings =
        InferenceEngine.generate_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings(
          rules_filtered_by_lhs_and_asserted_fact_template_names,
          facts,
          rules,
          mapper
        )
      |> process_mapping_for_assertion()

      assert processed_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings == sorted_expected_mappings
    end
  end

  def get_result_frequencies(facts) do
    Facts.get_asserted_facts(facts)
    |> Enum.filter(fn {_, {fact_template_name, _}} ->
      fact_template_name == Talisman.Test.Support.Fixtures.RuleTestResultFactTemplate
    end)
    |> Enum.map(fn {_, {_, result_pid}} ->
      Fact.get_field_values(result_pid)
      |> Map.get(:result)
    end)
    |> Enum.frequencies()
  end

  def process_mapping_for_assertion(mapping) do
    ack = mapping
    |> Enum.map(fn {rule_name, _, template_mappings} ->
      { rule_name,
        template_mappings
        |> Enum.map(fn template_mapping ->
          template_mapping
          |> Enum.map(fn {fact_template_name, _} ->
            fact_template_name
          end)
        end)
      }
    end)
    |> Enum.sort()
  end
end
