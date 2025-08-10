defmodule Talisman.ChinaLake do

  alias Talisman.MissileFactTemplate
  alias Talisman.BombFactTemplate
  alias Talisman.WarheadFactTemplate
  alias Talisman.PropulsionFactTemplate
  alias Talisman.Facts

  def load([facts]) do
    Facts.assert(
      facts,
      %MissileFactTemplate{
      name: :minuteman_ii,
      type: :icbm,
      propulsion: :solid_propellant,
      guidance: :ballistic_trajectory,
      warhead: :mirv
    })

    Facts.assert(
      facts,
      %MissileFactTemplate{
      name: :minuteman_ii,
      type: :icbm,
      propulsion: :solid_propellant,
      guidance: :ballistic_trajectory,
      warhead: :mirv
    })

    Facts.assert(
      facts,
      %MissileFactTemplate{
      name: :aim_9c_sidewinder,
      type: :air_to_air,
      propulsion: :solid_propellant,
      guidance: :semi_active_radar,
      warhead: :continuous_rod
    })

    Facts.assert(
      facts,
      %MissileFactTemplate{
      name: :aim_9c_sidewinder,
      type: :air_to_air,
      propulsion: :solid_propellant,
      guidance: :semi_active_radar,
      warhead: :continuous_rod
    })

    Facts.assert(
      facts,
      %BombFactTemplate{
      name: :b61,
      type: :gravity_bomb,
      guidance: :glide,
      warhead: :thermonuclear
    })

    Facts.assert(
      facts,
      %BombFactTemplate{
      name: :b61,
      type: :gravity_bomb,
      guidance: :glide,
      warhead: :thermonuclear
    })

    Facts.assert(
      facts,
      %BombFactTemplate{
      name: :b61,
      type: :gravity_bomb,
      guidance: :glide,
      warhead: :thermonuclear
    })

    Facts.assert(
      facts,
      %BombFactTemplate{
      name: :moab,
      type: :gravity_bomb,
      guidance: :gps,
      warhead: :fae
    })

    Facts.assert(
      facts,
      %BombFactTemplate{
      name: :blu_109,
      type: :gravity_bomb,
      guidance: :gps,
      warhead: :fae
    })

    Facts.assert(
      facts,
      %PropulsionFactTemplate{
      name: :"f107_wr_105/401",
      type: :turbofan,
      power: :"6.22_kN"
    })

    Facts.assert(
      facts,
      %WarheadFactTemplate{
      name: :W80,
      type: :thermonuclear,
      yield: :"21-628_TJ"
    })
  end
end
