defmodule SSSNE.GeneticsServerImpl do
  alias SSSNE.{PhenotypeEvaluator, GeneInitializer}

  def initialize_genome(%{
    num_parents: num_parents,
    num_genes: num_genes,
    initializer: initializer,
    evaluator: evaluator
  }) do
    num_parents
      |> initialize_parents
      |> Enum.reduce(%{}, fn (parent_id, acc) ->
        genes_for_parent = initialize_genes(
          num_genes, parent_id, initializer
        )

        fitness = PhenotypeEvaluator.evaluate(evaluator, genes_for_parent)

        Map.put(acc, parent_id, %{
          fitness: fitness,
          genes: genes_for_parent
        })
      end)
  end

  def initialize_parents(num_parents) do
    Enum.map(0..num_parents, fn _ -> random_id() end)
  end

  def initialize_genes(num_genes, parent_id, initializer) do
    Enum.reduce(0..num_genes, %{}, fn (i, acc) ->
      key = "#{parent_id}-#{i}"

      Map.put(acc, key, GeneInitializer.random_init(initializer))
    end)
  end

  defp random_id, do: Base.encode32(:crypto.strong_rand_bytes(10))
end
