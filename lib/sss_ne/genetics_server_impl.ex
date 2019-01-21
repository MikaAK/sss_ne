defmodule SSSNE.GeneticsServerImpl do
  alias SSSNE.{
    Utils,
    GenotypeEvaluator, GeneInitializer,
    GenomeMutation, GeneticKeyName
  }

  def initialize_genome(%{
    meta: meta,
    parent_count: parent_count,
    gene_count: gene_count,
    gene_trial_count: trial_count,
    initializer: initializer,
    evaluator: evaluator
  }) do
    parent_count
      |> initialize_parents
      |> Enum.with_index
      |> Enum.into(%{}, fn {parent_id, index} ->
        genes_for_parent = GeneInitializer.create_genes(
          initializer,
          parent_id,
          0..gene_count,
          meta
        )

        fitness = GenotypeEvaluator.evaluate(evaluator, genes_for_parent, trial_count, meta)

        {GeneticKeyName.parent_index_id(parent_id, index), %{
          noise_fitness: 0,
          fitness: fitness,
          genes: genes_for_parent
        }}
      end)
  end

  def initialize_parents(parent_count) do
    Enum.map(0..parent_count, fn _ -> Utils.random_id() end)
  end

  def genome_max_fitness(genome) do
    genome
      |> Enum.map(fn {_, %{fitness: fitness}} -> fitness end)
      |> Enum.max
  end

  def evolve_genes(%{
    genome: genome,
    meta: meta,
    reproduction_rate: reproduction_rate,
    gene_trial_count: gene_trials,
    max_fitness: max_fitness,
    evaluations: evaluations,
    evaluator: evaluator,
    genome: genome,
    mutator: mutator
  }) do
    acc = %{
      genome: genome,
      max_fitness: max_fitness,
      evaluations: evaluations + gene_trials
    }

    Enum.reduce(Enum.with_index(genome), acc, fn (
      {{parent_id, %{fitness: current_genes_fitness} = current_phenotype}, index},
      %{
        max_fitness: max_fitness,
        evaluations: evaluations,
        genome: genome
      }
    ) ->
      new_parent_id = GeneticKeyName.parent_index_id(parent_id, index)
      new_parent_genes = GenomeMutation.mutate(mutator, current_phenotype, new_parent_id, index, meta)
      new_fitness = GenotypeEvaluator.evaluate(evaluator, new_parent_genes, gene_trials, meta)

      evaluations = evaluations + gene_trials

      parent_noise_fitness = calculate_noise_fitness(
        max_fitness,
        reproduction_rate,
        current_genes_fitness
      )

      new_noise_fitness = calculate_noise_fitness(
        max_fitness,
        reproduction_rate,
        new_fitness
      )

      max_fitness = Utils.take_greater(max_fitness, new_fitness)

      %{
        max_fitness: max_fitness,
        evaluations: evaluations,
        genome: add_new_parent_to_genome(
          genome,
          {parent_id, parent_noise_fitness},
          {new_parent_id, new_noise_fitness, new_parent_genes, new_fitness}
        )
      }
    end)
  end

  defp add_new_parent_to_genome(
    genome,
    {parent_id, parent_noise_fitness},
    {new_parent_id, new_noise_fitness, new_parent_genes, new_fitness}
  ) do
    new_parent = %{
      noise_fitness: new_noise_fitness,
      genes: new_parent_genes,
      fitness: new_fitness
    }

    genome
      |> Map.update!(parent_id, &(Map.put(&1, :noise_fitness, parent_noise_fitness)))
      |> Map.put(new_parent_id, new_parent)
  end

  defp calculate_noise_fitness(max_fitness, reproduction_rate, current_fitness) do
    stochasticity_min = -reproduction_rate * max_fitness
    stochasticity_max = reproduction_rate * max_fitness
    stochasticity_random = Utils.random_float(stochasticity_min, stochasticity_max)

    current_fitness * (1.0 + stochasticity_random)
  end

  def rank_select_genes(%{genome: genome, parent_count: parent_count} = state) do
    genome = genome
      |> Enum.sort_by(fn {_, %{noise_fitness: noise_fitness}} -> noise_fitness end, &Kernel.>=/2)
      |> Enum.take(parent_count)
      |> Map.new

    Map.put(state, :genome, genome)
  end
end
