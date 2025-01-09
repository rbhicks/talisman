defmodule Athena.Test.Fixtures.MissileFactTemplate do
  use GenServer
  use Athena.Fact

  defstruct type: nil, propulsion: nil, seeker: nil, warhead: nil
end

