defmodule TalismanTest do
  use ExSpec, async: true

  require DefRule

  alias Talisman.Test.Support.Fixtures.MissileFactTemplate
  alias Talisman.Test.Support.Fixtures.BombFactTemplate
  alias Talisman.Test.Support.Fixtures.WarheadFactTemplate
  alias Talisman.Test.Support.Fixtures.PropulsionFactTemplate
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
          []
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
          [[facts: facts, rules: rules, mapper: mapper]]
        }
      }

    inference_engine = start_supervised!(inference_engine_child_spec)

    Facts.assert(
      facts,
      %MissileFactTemplate{
        name: :minuteman_ii,
        type: :icbm,
        propulsion: :solid_propellant,
        guidance: :ballistic_trajectory,
        warhead: :mirv
      },
      mapper
    )

    Facts.assert(
      facts,
      %MissileFactTemplate{
        name: :aim_9c_sidewinder,
        type: :air_to_air,
        propulsion: :solid_propellant,
        guidance: :semi_active_radar,
        warhead: :continuous_rod
      },
      mapper
    )

    Facts.assert(
      facts,
      %MissileFactTemplate{
        name: :aim_9c_sidewinder,
        type: :air_to_air,
        propulsion: :solid_propellant,
        guidance: :semi_active_radar,
        warhead: :continuous_rod
      },
      mapper
    )

    Facts.assert(
      facts,
      %BombFactTemplate{
        name: :b61,
        type: :gravity_bomb,
        guidance: :glide,
        warhead: :thermonuclear
      },
      mapper
    )

    Facts.assert(
      facts,
      %PropulsionFactTemplate{
        name: :f107_wr_400,
        type: :turbofan,
        power: :"2.7_kN"
      },
      mapper
    )

    Facts.assert(
      facts,
      %PropulsionFactTemplate{
        name: :"f107_wr_105/401",
        type: :turbofan,
        power: :"6.22_kN"
      },
      mapper
    )

    Facts.assert(
      facts,
      %WarheadFactTemplate{
        name: :W80,
        type: :thermonuclear,
        yield: :"21-628_TJ"
      },
      mapper
    )

    DefRule.def_rule(rules, :found_icbm, fn %MissileFactTemplate{} = missile ->
      fn ->
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # missile |> IO.inspect(limit: :infinity)
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        true
      end

      fn ->
        "()()()()()()()()()()()()()()()()()()" |> IO.puts()
        "fox-1" |> IO.puts()
        "()()()()()()()()()()()()()()()()()()" |> IO.puts()
      end
    end)

    DefRule.def_rule(rules, :assess_total_missile_yield, fn %MissileFactTemplate{} = missile,
                                                            %WarheadFactTemplate{} = warhead ->
      fn ->
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # missile |> IO.inspect(limit: :infinity)
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        false
      end

      fn ->
        "()()()()()()()()()()()()()()()()()()" |> IO.puts()
        "fox-1" |> IO.puts()
        "()()()()()()()()()()()()()()()()()()" |> IO.puts()
      end
    end)

    DefRule.def_rule(rules, :found_f22_aim_9c_loadout, fn %MissileFactTemplate{} = sidewinder_0,
                                                          %MissileFactTemplate{} = sidewinder_1 ->
      fn ->
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # sidewinder_0 |> IO.inspect(limit: :infinity)
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        false
      end

      fn ->
        "()()()()()()()()()()()()()()()()()()" |> IO.puts()
        "fox-1" |> IO.puts()
        "()()()()()()()()()()()()()()()()()()" |> IO.puts()
      end
    end)

    DefRule.def_rule(rules, :found_jet_powered_missile, fn %MissileFactTemplate{} = missile,
                                                           %PropulsionFactTemplate{} = propulsion ->
      fn ->
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # propulsion |> IO.inspect(limit: :infinity)
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        true
      end

      fn ->
        "()()()()()()()()()()()()()()()()()()" |> IO.puts()
        "fox-1" |> IO.puts()
        "()()()()()()()()()()()()()()()()()()" |> IO.puts()
      end
    end)

    DefRule.def_rule(rules, :found_nuclear_cruise_missile, fn %WarheadFactTemplate{} = warhead,
                                                              %PropulsionFactTemplate{} =
                                                                propulsion,
                                                              %MissileFactTemplate{} = missile ->
      fn ->
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" |> IO.puts()
        # warhead |> IO.inspect(limit: :infinity)
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        # "+++++++++++++++++++++++++++++++++++" |> IO.puts()
        true
      end

      fn ->
        "()()()()()()()()()()()()()()()()()()" |> IO.puts()
        "fox-1" |> IO.puts()
        "()()()()()()()()()()()()()()()()()()" |> IO.puts()
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

    %{
      facts_supervisor: facts_supervisor,
      rules_supervisor: rules_supervisor,
      facts: facts,
      rules: rules,
      inference_engine: inference_engine,
      mapper: mapper
    }
  end

  describe "basic fact, rule, and candidacy functionality" do
    #   @tag :skip
    it "facts_supervisor is created successfully", %{facts_supervisor: facts_supervisor} do
      assert is_pid(facts_supervisor)
    end

    #   @tag :skip
    it "facts is created successfully", %{facts: facts} do
      assert is_pid(facts)
    end

    #   @tag :skip
    it "facts are asserted (added not test 'asserted' correctly", %{facts: facts} do
      for {fact_id, fact_template, fact_pid} <- Facts.get_asserted_facts(facts) do
        assert is_binary(fact_id)
        assert is_struct(fact_template)
        assert is_pid(fact_pid)
      end
    end

    #   @tag :skip
    it "rules_supervisor is created successfully", %{rules_supervisor: rules_supervisor} do
      assert is_pid(rules_supervisor)
    end

    #   @tag :skip
    it "rules is created successfully", %{rules: rules} do
      assert is_pid(rules)
    end

    #   @tag :skip
    it "rules are added correctly", %{rules: rules} do
      for {rule_id, rule_name, rule_pid} <- Rules.get_rules(rules) do
        assert is_atom(rule_id)
        assert is_atom(rule_name)
        assert is_pid(rule_pid)
      end
    end

    #   @tag :skip
    it "inference_engine is created successfully", %{inference_engine: inference_engine} do
      assert is_pid(inference_engine)
    end

    #   @tag :skip
    it "mapper is created successfully", %{mapper: mapper} do
      assert is_pid(mapper)
    end

    #   @tag :skip
    it "rule candidacy checks works", %{inference_engine: inference_engine} do
      InferenceEngine.filter_rules_by_rule_lhs_and_asserted_fact_template_names(inference_engine)

      InferenceEngine.generate_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings(
        inference_engine
      )

      InferenceEngine.filter_rules_by_rule_lhs_and_asserted_fact_multiplicity(inference_engine)
      InferenceEngine.generate_candidate_rule_activations(inference_engine)
      InferenceEngine.generate_activated_rules(inference_engine)

      "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts()
      "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts()
      "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" |> IO.puts()

      # InferenceEngine.get_rules_filtered_by_lhs_and_asserted_fact_template_names(inference_engine)
      # |> IO.inspect(limit: :infinity)

      # "============================================================" |> IO.puts()

      # InferenceEngine.get_rule_name_rule_pid_fact_template_name_asserted_fact_pid_mappings(
      #   inference_engine
      # )
      # |> IO.inspect(limit: :infinity)

      # "============================================================" |> IO.puts()

      # InferenceEngine.get_rules_filtered_by_rule_lhs_and_asserted_fact_multiplicity(
      #   inference_engine
      # )
      # |> IO.inspect(limit: :infinity)

      # "============================================================" |> IO.puts()

      InferenceEngine.get_candidate_rule_activations(inference_engine)
      |> IO.inspect(limit: :infinity)

      "============================================================" |> IO.puts()

      InferenceEngine.get_activated_rules(inference_engine)
      |> IO.inspect(limit: :infinity)

      "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts()
      "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts()
      "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" |> IO.puts()
    end
  end
end
