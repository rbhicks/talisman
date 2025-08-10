defmodule Talisman.MissileFactTemplate do
  defstruct id: nil, name: nil, type: nil, propulsion: nil, guidance: nil, warhead: nil
end

defmodule Talisman.BombFactTemplate do
  defstruct id: nil, name: nil, type: nil, guidance: nil, warhead: nil
end

defmodule Talisman.GuidanceFactTemplate do
  defstruct id: nil, name: nil, type: nil, power_source: nil
end

defmodule Talisman.WarheadFactTemplate do
  defstruct id: nil, name: nil, type: nil, yield: nil
end

defmodule Talisman.PropulsionFactTemplate do
  defstruct id: nil, name: nil, type: nil, power: nil
end

defmodule Talisman.RuleTestResultFactTemplate do
  defstruct id: nil, result: nil
end
