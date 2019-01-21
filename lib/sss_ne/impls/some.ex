defmodule SSSNE.Impls.Some do
  alias SSSNE.{GenotypeEvaluator, GenomeMutation, GeneInitializer}

  @behaviour GeneInitializer
  @behaviour GenomeMutation
  @behaviour GenotypeEvaluator

  @mutations [:add_half, :add_one, :sub_one, :sub_half]

  @impl GenotypeEvaluator
  def evaluate(genes, _trial_num, _meta) do
    genes |> Map.values |> Enum.sum
  end

  @impl GenomeMutation
  def mutate(%{genes: genes}, new_parent_id, _index, _meta) do
    genes
      |> Enum.with_index
      |> Enum.into(%{}, fn {{_, gene}, index} ->
        mutation = Enum.random(@mutations)
        gene_key = SSSNE.GeneticKeyName.gene_index_id(new_parent_id, index)

        {gene_key, mutate_gene(mutation, gene)}
      end)
  end

  defp mutate_gene(:add_half, gene), do: gene + 0.5
  defp mutate_gene(:add_one, gene), do: gene + 1
  defp mutate_gene(:sub_one, gene), do: gene + 1
  defp mutate_gene(:sub_half, gene), do: gene + 0.5

  @impl GeneInitializer
  def create_genes(parent_id, gene_index_list, _meta) do
    Enum.into(gene_index_list, %{}, fn i ->
      key = SSSNE.GeneticKeyName.gene_index_id(parent_id, i)

      {key, random_init()}
    end)
  end

  defp random_init do
    Enum.random(-8..8)
  end
end
