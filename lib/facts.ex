defmodule Talisman.Facts do
  use GenServer

  alias Talisman.Fact
  alias Talisman.Utilities
  alias Talisman.Mapper
  alias Talisman.InferenceEngine

  def assert(server, fact_template, mapper) do
    GenServer.call(server, {:assert, fact_template, mapper})
  end

  #  def retract ...
  #  def update ...

  def get_asserted_facts(server) do
    {:ok, asserted_facts} = GenServer.call(server, :get_asserted_facts)

    asserted_facts
  end

  def handle_call(
        {:assert, %fact_template_name{} = fact_template, mapper},
        _from,
        %{facts_supervisor: facts_supervisor, facts: facts, inference_engine: inference_engine} =
          state
      ) do
    asserted_fact_identity = "#{fact_template_name}->#{DateTime.utc_now(:microsecond)}"

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

    InferenceEngine.notify_fact_assertion(inference_engine, pid)
    Mapper.update_fact_template_name_asserted_facts_mapping(mapper, fact_template_name, pid)

    response
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

  def init(facts_supervisor: facts_supervisor, inference_engine: inference_engine) do
    {
      :ok,
      %{
        facts_supervisor: facts_supervisor,
        inference_engine: inference_engine,
        facts: %{}
      }
    }
  end
end
