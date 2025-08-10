defmodule Talisman.ChinaLake do

  require DefRule
  
  alias Talisman.MissileFactTemplate
  alias Talisman.BombFactTemplate
  alias Talisman.WarheadFactTemplate
  alias Talisman.PropulsionFactTemplate
  alias Talisman.RuleTestResultFactTemplate
  alias Talisman.Facts

  def load(facts) do
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
  end

  def compile_rules(facts, rules) do
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
        Facts.retract(
          facts,
          bomb.id
        )

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
        Facts.update(
          facts,
          bomb.id,
          %{name: :mop}
        )

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
  end
end
