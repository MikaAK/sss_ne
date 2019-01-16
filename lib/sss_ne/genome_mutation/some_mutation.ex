defmodule SSSNE.GenomeMutation.SomeMutation do
  alias SSSNE.GenomeMutation

  @behaviour GenomeMutation

  @mutations [:add_half, :add_one, :sub_one, :sub_half]

  @impl GenomeMutation
  def mutate(%{genes: genes}, new_parent_id) do
    genes
      |> Enum.with_index
      |> Enum.into(%{}, fn {{_, gene}, index} ->
        mutation = Enum.random(@mutations)
        gene_key = SSSNE.GeneticKeyName.gene_index_id(new_parent_id, index)

        {gene_key, mutate_gene(mutation, gene)}
      end)
  end

  def mutate_gene(:add_half, gene), do: gene + 0.5
  def mutate_gene(:add_one, gene), do: gene + 1
  def mutate_gene(:sub_one, gene), do: gene + 1
  def mutate_gene(:sub_half, gene), do: gene + 0.5
end
