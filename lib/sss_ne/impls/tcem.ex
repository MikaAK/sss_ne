defmodule SSSNE.Impls.TCEM do
  @moduledoc """
  Triple Codon Encoding Method
  """

  alias SSSNE.{GenotypeEvaluator, GenomeMutation, GeneInitializer}
  alias SSSNE.Impls.TCEM.{
    ComponentDecoder, EncodingConfig,
    NetworkRepresentationMapper
  }

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
    Enum.map(gene_index_range, &create_random_genome(&1, inputs, outputs, layers))
  end

  def create_random_genome(index, inputs, outputs, layers) do
    genome = random_initial_genes(inputs, outputs, layers)
    input_length = length(inputs)
    output_length = length(outputs)
    component_length = length(layers) + input_length + output_length

    %{
      index: index,
      genome: genome,
      fitness: nil,
      config: EncodingConfig.create(
        ComponentDecoder.SubNet,
        NetworkRepresentationMapper.Test,
        input_length,
        output_length,
        component_length
      )
    }
  end

  defp random_initial_genes(inputs, outputs, layers) do
    "TAC CCT AGT CGT TTC AGC TCG CTA CCC TAG ACA CCG"
  end
end
