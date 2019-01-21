defmodule SSSNE.Impls.TCEM.NetworkRepresentationMapper do
  @type t :: module
  @type nodes :: any

  @callback representation_index(integer) :: any
  @callback create_network(inputs :: nodes, middles :: nodes, outputs :: nodes) :: any

  @spec representation_index(t, integer) :: any
  def representation_index(module, triple_codon_int) do
    module.representation_index(triple_codon_int)
  end

  @spec create_network(t, nodes, nodes, nodes) :: any
  def create_network(module, input_nodes, middle_nodes, output_nodes) do
    module.create_network(input_nodes, middle_nodes, output_nodes)
  end
end
