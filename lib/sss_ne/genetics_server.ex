defmodule SSSNE.GeneticsServer do
  use GenServer

  alias SSSNE.{
    Impls,
    GeneticsServerImpl, GenomeMutation,
    GeneInitializer, GenotypeEvaluator
  }

  @type phenotype :: %{
    genes: %{required(String.t) => integer},
    noise_fitness: integer,
    fitness: integer
  }

  @type genome :: %{required(String.t) => phenotype}

  @type state :: %{
    meta: map,
    genome: genome,
    mutator: GenomeMutation.t,
    initializer: GeneInitializer.t,
    evaluator: GenotypeEvaluator.t,
    reproduction_rate: float,
    max_evaluations: integer,
    gene_trial_count: integer,
    parent_count: integer,
    gene_count: integer
  }

  defmodule Config do
    defstruct [
      mutator: Impls.Some,
      initializer: Impls.Some,
      evaluator: Impls.Some,
      meta: %{},
      max_evaluations: 1_000,
      gene_trial_count: 10,
      parent_count: 10,
      gene_count: 10,
      reproduction_rate: 0.8
    ]
  end

  @name SSSNE.GeneticsServer
  @timeout :timer.seconds(30)

  # API
  def start_link(%Config{
    mutator: mutator,
    initializer: initializer,
    evaluator: evaluator,
    meta: meta,
    gene_trial_count: gene_trial_count,
    parent_count: parent_count,
    gene_count: gene_count,
    max_evaluations: max_evaluations,
    reproduction_rate: reproduction_rate
  }, opts \\ [name: @name]) do
    GenServer.start_link(SSSNE.GeneticsServer, %{
      meta: meta,
      mutator: mutator,
      initializer: initializer,
      reproduction_rate: reproduction_rate,
      evaluator: evaluator,
      gene_trial_count: gene_trial_count,
      max_evaluations: max_evaluations,
      parent_count: parent_count,
      gene_count: gene_count
    }, opts)
  end

  def run_evaluations(num) do
    1..num
      |> Enum.map(fn _ ->
        reset_evaluation_count()
        run_evaluations()
      end)
      |> List.last
  end

  def run_evaluations do
    GenServer.call(@name, :run_evaluations, @timeout)
  end

  def reset_evaluation_count do
    GenServer.call(@name, :reset_evaluation_count, @timeout)
  end

  # Server
  def init(state) do
    genome = GeneticsServerImpl.initialize_genome(state)

    {:ok, Map.merge(%{
      genome: genome,
      max_fitness: GeneticsServerImpl.genome_max_fitness(genome),
      evaluations: 0,
      evolutions: 0
    }, state)}
  end

  def handle_call(:reset_evaluation_count, _, state) do
    new_state = %{state | evaluations: 0}

    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call(:run_evaluations, _, state) do
    new_state = evaluate_and_evolve(state)

    {:reply, {:ok, new_state}, new_state}
  end

  defp evaluate_and_evolve(%{max_evaluations: max_evals, evolutions: evolutions} = state) do
    task = Task.async(fn -> evolve_genes(state) end)

    %{
      evaluations: evaluations,
      max_fitness: max_fitness,
      genome: genome
    } = Task.await(task, @timeout)

    new_state = %{state |
      evolutions: evolutions + 1,
      evaluations: evaluations,
      max_fitness: max_fitness,
      genome: genome
    }

    if new_state.evaluations < max_evals do
      evaluate_and_evolve(new_state)
    else
      new_state
    end
  end

  defp evolve_genes(state) do
    new_state = GeneticsServerImpl.evolve_genes(state)

    state
      |> Map.merge(new_state)
      |> GeneticsServerImpl.rank_select_genes
  end
end
