defmodule Athena.Test.Support.Fixtures.MissileFactTemplate do
  defstruct name: nil, type: nil, propulsion: nil, guidance: nil, warhead: nil
end

defmodule Athena.Test.Support.Fixtures.BombFactTemplate do
  defstruct name: nil, type: nil, guidance: nil, warhead: nil
end

defmodule Athena.Test.Support.Fixtures.GuidanceFactTemplate do
  defstruct name: nil, type: nil, power_source: nil
end

defmodule Athena.Test.Support.Fixtures.WarheadFactTemplate do
  defstruct name: nil, type: nil, yield: nil
end

defmodule Athena.Test.Support.Fixtures.PropulsionFactTemplate do
  defstruct name: nil, type: nil, power: nil
end
