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
#      NoiseFitness[p] = Fitness[p]  *
#        (1.0 + rand(-Stochasticity * MaxFit, Stochasticity * MaxFit))
#
#      NoiseFitness[p+NParents] = Fitness[p+NParents] *
#        (1.0 + rand(-Stochasticity * MaxFit, Stochasticity * MaxFit))
#
#  // the best among parents and offspring become the new parents
#  rank genome[NParents * 2] for NoiseFitness[NParents * 2]

defmodule SSSNE.PhenotypeEvaluator.SomeEvaluator do
  alias SSSNE.PhenotypeEvaluator

  @behaviour PhenotypeEvaluator

  @impl PhenotypeEvaluator
  def evaluate(genes, _trial_num) do
    genes |> Map.values |> Enum.sum
  end
end
