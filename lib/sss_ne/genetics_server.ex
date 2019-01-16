#  NEvaluations <- 0
# // the genotype of the parents of the first generation in initialized randomly
#  for p = 0 to NParents do
#    for g = 0 to NGenes do
#      genome[p][g] = rand(-8.0, 8.0)
#
#    Fitness[p] = evaluate (p)
#    NEvaluations = NEvaluations + NTrials
#  // evolution is continued until a maximum number of evaluation trials is performed
#  while(NEvaluations < MaxEvaluations) do
#    for p = 0 to NParents do
#      // in the randomly varying experimental condition parents are re-evaluated
#      if (RandomlyVaryingInitialCondition) then
#        Fitness[p] = evaluate (p)
#        NEvaluations = NEvaluations + NTrials
#
#      genome[p+NParents] = genome[p] // create a copy of parents’ genome
#      mutate-genome(p+NParents) // mutate the genotype of the offspring
#      Fitness[p+Nparents] = evaluate[p+NParents]
#      NEvaluations = NEvaluations + NTrials // noise ensures that parents are replaced by less fit offspring with a low probability
#      NoiseFitness[p] = Fitness[p]  * (1.0 + rand(-StochasticityMaxFit, StochasticityMaxFit))
#      NoiseFitness[p+NParents] = Fitness[p+NParents] * (1.0 + rand(-StochasticityMaxFit, StochasticityMaxFit))
#  // the best among parents and offspring become the new parents
#  rank genome[NParents2] for NoiseFitness[NParents2]

defmodule SSSNE.GeneticsServer do
  use GenServer

  alias SSSNE.{
    GeneticsServerImpl, GenomeMutation,
    GeneInitializer, PhenotypeEvaluator
  }

  @type genome :: %{required(integer) => integer}
  @type state :: %{
    reproduction_rate: integer, # Stochasticity
    num_parents: integer,
    num_genes: integer,
    genome: genome,
    mutator: GenomeMutation.t,
    initializer: GenomeInitializer.t
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
    reproduction_rate \\ 0.8,
    opts \\ [name: @name]
  ) do
    GenServer.start_link(SSSNE.GeneticsServer, %{
      mutator: mutator,
      initializer: initializer,
      reproduction_rate: reproduction_rate,
      evaluator: evaluator,
      num_parents: num_parents,
      num_genes: num_genes
    }, opts)
  end

  def predict(inputs) do
    GenServer.call(@name, {:predict_phenotype, inputs}, timeout: @timeout)
  end

  # Server
  def init(state) do
    {:ok, Map.merge(%{
      genome: GeneticsServerImpl.initialize_genome(state)
    }, state)}
  end

  def handle_call({:predict, inputs}, _, state) do
  end
end
