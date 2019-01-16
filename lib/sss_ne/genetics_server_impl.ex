defmodule SSSNE.GeneticsServerImpl do
  alias SSSNE.{
    PhenotypeEvaluator, GeneInitializer,
    GenomeMutation, GeneticKeyName
  }

  def initialize_genome(%{
    num_parents: num_parents,
    num_genes: num_genes,
    num_gene_trials: num_trials,
    initializer: initializer,
    evaluator: evaluator
  }) do
    num_parents
      |> initialize_parents
      |> Enum.with_index
      |> Enum.into(%{}, fn {parent_id, index} ->
        genes_for_parent = initialize_genes(
          num_genes, parent_id, initializer
        )

        fitness = PhenotypeEvaluator.evaluate(evaluator, genes_for_parent, num_trials)

        {GeneticKeyName.parent_index_id(parent_id, index), %{
          noise_fitness: 0,
          fitness: fitness,
          genes: genes_for_parent
        }}
      end)
  end

  def initialize_parents(num_parents) do
    Enum.map(0..num_parents, fn _ -> random_id() end)
  end

  def initialize_genes(num_genes, parent_id, initializer) do
    Enum.into(0..num_genes, %{}, fn i ->
      key = GeneticKeyName.gene_index_id(parent_id, i)

      {key, GeneInitializer.random_init(initializer)}
    end)
  end

  defp random_id, do: Base.encode32(:crypto.strong_rand_bytes(10))

  def genome_max_fitness(genome) do
    genome
      |> Enum.map(fn {_, %{fitness: fitness}} -> fitness end)
      |> Enum.max
  end

  def evolve_genes_func(%{
    reproduction_rate: reproduction_rate,
    num_gene_trials: gene_trials,
    max_evaluations: max_evals,
    evaluator: evaluator,
    mutator: mutator
  }) do
    fn
      (_, %{evaluations: evaluations} = acc) when evaluations > max_evals ->
        {:halt, acc}

      (
        {{parent_id, %{fitness: current_genes_fitness} = current_phenotype}, index},
        %{
          max_fitness: max_fitness,
          evaluations: evaluations,
          genome: genome
        }
      ) ->
        new_parent_id = GeneticKeyName.parent_index_id(parent_id, index)
        new_parent_genes = GenomeMutation.mutate(mutator, new_parent_id, current_phenotype)
        new_fitness = PhenotypeEvaluator.evaluate(evaluator, new_parent_genes, gene_trials)

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

        max_fitness = take_greater(max_fitness, new_fitness)

        {:cont, %{
          max_fitness: max_fitness,
          evaluations: evaluations,
          genome: add_new_parent_to_genome(
            genome,
            {parent_id, parent_noise_fitness},
            {new_parent_id, new_noise_fitness, new_parent_genes, new_fitness}
          )
        }}
    end
  end

  defp add_new_parent_to_genome(
    genome,
    {parent_id, parent_noise_fitness},
    {new_parent_id, new_noise_fitness, new_parent_genes, new_fitness}
  ) do
    new_parent = %{
      noise_fitness: new_noise_fitness,
      genes: new_parent_genes, fitness: new_fitness
    }

    genome
      |> Map.update!(parent_id, &(Map.put(&1, :noise_fitness, parent_noise_fitness)))
      |> Map.put(new_parent_id, new_parent)
  end

  defp take_greater(item_a, item_b) when item_a > item_b, do: item_a
  defp take_greater(item_a, item_b) when item_a < item_b, do: item_b

  defp calculate_noise_fitness(max_fitness, reproduction_rate, current_fitness) do
    stochasticity_min = -reproduction_rate * max_fitness
    stochasticity_max = reproduction_rate * max_fitness
    stochasticity_random = random_float(stochasticity_min, stochasticity_max)

    current_fitness * (1.0 + stochasticity_random)
  end

  defp random_float(min, max) do
    (max - min) * :rand.uniform() + min
  end
end
