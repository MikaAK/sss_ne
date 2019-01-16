defmodule SSSNE.GeneticsServer do
  use GenServer

  alias SSSNE.{
    GeneticsServerImpl, GenomeMutation,
    GeneInitializer, PhenotypeEvaluator
  }

  @type phenotype :: %{
    genes: %{required(String.t) => integer},
    noise_fitness: integer,
    fitness: integer
  }

  @type genome :: %{required(String.t) => phenotype}

  @type state :: %{
    trial_count: integer,
    genome: genome,
    mutator: GenomeMutation.t,
    initializer: GeneInitializer.t,
    reproduction_rate: float,
    evaluator: PhenotypeEvaluator.t,
    num_gene_trials: integer,
    max_evaluations: integer,
    num_parents: integer,
    num_genes: integer
  }

  @name SSSNE.GeneticsServer
  @timeout :timer.seconds(30)

  # API
  def start_link(
    mutator \\ GenomeMutation.SomeMutation,
    initializer \\ GeneInitializer.SomeInitializer,
    evaluator \\ PhenotypeEvaluator.SomeEvaluator,
    num_parents \\ 10,
    num_genes \\ 10,
    max_evaluations \\ 10_000,
    num_gene_trials \\ 20,
    reproduction_rate \\ 0.8,
    opts \\ [name: @name]
  ) do
    GenServer.start_link(SSSNE.GeneticsServer, %{
      mutator: mutator,
      initializer: initializer,
      reproduction_rate: reproduction_rate,
      evaluator: evaluator,
      num_gene_trials: num_gene_trials,
      max_evaluations: max_evaluations,
      num_parents: num_parents,
      num_genes: num_genes
    }, opts)
  end

  def run_evaluations do
    GenServer.call(@name, :run_evaluations, @timeout)
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
