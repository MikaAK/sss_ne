defmodule SSSNE.Impls.TCEM do
  @moduledoc """
  Triple Codon Encoding Method
  """

  alias SSSNE.{GenotypeEvaluator, GenomeMutation, GeneInitializer}

  @type meta :: %{inputs: integer, outputs: integer, layers: integer}

  @behaviour GeneInitializer
  @behaviour GenomeMutation
  @behaviour GenotypeEvaluator

  @impl GenotypeEvaluator
  def evaluate(genes, _trial_num, _meta) do
  end

  @impl GenomeMutation
  def mutate(%{genes: genes}, new_parent_id, index, _meta) do
    genes
  end

  @impl GeneInitializer
  def create_genes(parent_id, gene_index_range, %{
    inputs: inputs,
    outputs: outputs,
    layers: layers
  }) do
    Enum.map(gene_index_range, &"#{&1}-#{random_initial_genes(inputs, outputs, layers)}")
  end

  defp random_initial_genes(inputs, outputs, layers) do

  end
end
