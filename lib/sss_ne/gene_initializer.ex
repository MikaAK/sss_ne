defmodule SSSNE.GeneInitializer do
  @type t :: module

  @callback create_genes(String.t, list(integer), map) :: any

  @spec create_genes(t, String.t, list(integer), map) :: any
  def create_genes(module, parent_id, gene_index_list, meta) do
    module.create_genes(parent_id, gene_index_list, meta)
  end
end
