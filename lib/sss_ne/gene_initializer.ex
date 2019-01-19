defmodule SSSNE.GeneInitializer do
  @type t :: module

  @callback create_genes(String.t, list(integer)) :: any

  @spec create_genes(t, String.t, list(integer)) :: any
  def create_genes(module, parent_id, gene_index_list) do
    module.create_genes(parent_id, gene_index_list)
  end
end
