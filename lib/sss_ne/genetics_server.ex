defmodule SSSNE.GeneticsServer do
  use GenServer

  alias SSSNE.{
    GeneticsServerImpl, GenomeMutation,
    GeneInitializer, PhenotypeEvaluator
  }

  @type genome :: %{required(integer) => integer}
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
      evaluations: 0
    }, state)}
  end

  def handle_call(:run_evaluations, _, %{
    genome: genome,
    max_fitness: max_fitness,
    num_gene_trials: gene_trials,
    evaluations: evaluations
  } = state) do
    acc = %{
      genome: genome,
      max_fitness: max_fitness,
      evaluations: evaluations + gene_trials
    }

    %{
      evaluations: evaluations,
      max_fitness: max_fitness,
      genome: genome
    } = genome
      |> Enum.with_index
      |> Enum.reduce_while(
        acc,
        GeneticsServerImpl.evolve_genes_func(state)
      )

    new_state = %{state |
      evaluations: evaluations,
      max_fitness: max_fitness,
      genome: genome
    }

    {:reply, {:ok, new_state}, new_state}
  end
end
