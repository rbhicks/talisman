defmodule Talisman.Facts do
  use GenServer

  alias Talisman.Fact
  alias Talisman.Utilities
  alias Talisman.Mapper
  alias Talisman.InferenceEngine

  def assert(server, fact_template) do
    GenServer.call(server, {:assert, fact_template})
  end

  def retract(server, fact_id) do
    GenServer.call(server, {:retract, fact_id})
  end

  #  def update ...

  def get_asserted_facts(server) do
    {:ok, asserted_facts} = GenServer.call(server, :get_asserted_facts)

    asserted_facts
  end

  def handle_call(
        {:assert, %fact_template_name{} = fact_template},
        _from,
        %{
          facts_supervisor: facts_supervisor,
          facts: facts,
          inference_engine: inference_engine,
          mapper: mapper
        } =
          state
      ) do
    asserted_fact_identity = "#{fact_template_name}->#{DateTime.utc_now(:microsecond)}"

    fact_template = %{fact_template | id: asserted_fact_identity}

    response =
      Utilities.generate_fact_assertion_or_rule_addition_response(
        facts_supervisor,
        %{
          id: asserted_fact_identity,
          start: {
            Fact,
            :start,
            [
              fact_template,
              asserted_fact_identity
            ]
          }
        },
        facts,
        fact_template_name,
        :facts,
        state
      )

    {_, {_, pid}, _} = response

    Mapper.update_fact_template_name_asserted_facts_mapping_for_assert(
      mapper,
      fact_template_name,
      pid
    )

    response
  end

  def handle_call({:retract, fact_id}, _, %{facts: asserted_facts, mapper: mapper} = state) do
    {_, fact_pid} = Map.get(asserted_facts, fact_id)

    GenServer.stop(fact_pid)

    Mapper.update_fact_template_name_asserted_facts_mapping_for_retract(mapper, fact_pid)

    asserted_facts = Map.delete(asserted_facts, fact_id)

    {
      :reply,
      :ok,
      state
      |> Map.put(:facts, asserted_facts)
    }
  end

  def handle_call(:get_asserted_facts, _from, %{facts: facts} = state) do
    {
      :reply,
      {:ok, facts},
      state
    }
  end

  def start(params) do
    GenServer.start_link(__MODULE__, params)
  end

  def init(facts_supervisor: facts_supervisor, inference_engine: inference_engine, mapper: mapper) do
    {
      :ok,
      %{
        facts_supervisor: facts_supervisor,
        inference_engine: inference_engine,
        mapper: mapper,
        facts: %{}
      }
    }
  end
end
