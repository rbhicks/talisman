# for mapping, the fact template structs are 'looked at' directly...i.e. the map keys.
# template are also used for assertion of facts...or should this be changed with the template
# passed to the fact...probably this...

defmodule Athena.Test.Support.Fixtures.MissileFactTemplate do
  
  use GenServer
  use Athena.Fact

  defstruct type: nil, propulsion: nil, seeker: nil, warhead: nil
end

