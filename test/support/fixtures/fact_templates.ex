defmodule Talisman.Test.Support.Fixtures.MissileFactTemplate do
  defstruct id: nil, name: nil, type: nil, propulsion: nil, guidance: nil, warhead: nil
end

defmodule Talisman.Test.Support.Fixtures.BombFactTemplate do
  defstruct id: nil, name: nil, type: nil, guidance: nil, warhead: nil
end

defmodule Talisman.Test.Support.Fixtures.GuidanceFactTemplate do
  defstruct id: nil, name: nil, type: nil, power_source: nil
end

defmodule Talisman.Test.Support.Fixtures.WarheadFactTemplate do
  defstruct id: nil, name: nil, type: nil, yield: nil
end

defmodule Talisman.Test.Support.Fixtures.PropulsionFactTemplate do
  defstruct id: nil, name: nil, type: nil, power: nil
end

defmodule Talisman.Test.Support.Fixtures.RuleTestResultFactTemplate do
  defstruct id: nil, result: nil
end
